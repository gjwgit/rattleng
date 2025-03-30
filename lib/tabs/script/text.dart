/// A text widget to display the R script for the SCRIPT tab.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2025-03-30 11:45:43 +1100 Graham Williams>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/tabs/script/save_button.dart';

/// Create a script text viewer that can scroll the text of the script widget.
///
/// The contents is intialised from the main.R script asset.

class ScriptText extends ConsumerStatefulWidget {
  const ScriptText({super.key});

  @override
  _ScriptTextState createState() => _ScriptTextState();
}

class _ScriptTextState extends ConsumerState<ScriptText> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // FocusNode for the search field.

  final FocusNode _searchFocusNode = FocusNode();

  bool _showSearchBar = false;
  List<int> _matchIndices = [];
  int _currentMatchIndex = 0;

  // A rough assumption for line height (used for scrolling to matched lines).

  final double _lineHeight = 20.0;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the script from the provider.

    final script = ref.watch(scriptProvider);

    // Build the text widget. If there's a non-empty search query with matches,
    // we rebuild the text with highlighted spans.

    Widget scriptWidget;
    scriptWidget = _searchController.text.isNotEmpty && _matchIndices.isNotEmpty
        ? SelectableText.rich(
            TextSpan(
              children: buildHighlightSpans(
                script,
                _searchController.text,
                _matchIndices,
                _currentMatchIndex,
              ),
            ),
            key: scriptTextKey,
          )
        : SelectableText(
            script,
            key: scriptTextKey,
            style: monoSmallTextStyle,
          );

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // The search bar at the top (only visible if _showSearchBar is true).

            if (_showSearchBar) _buildSearchBar(context, script),

            // Expanded area for the scrollable text content.

            Expanded(
              child: Stack(
                children: [
                  // Main scrollable script content.

                  Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: scriptWidget,
                      ),
                    ),
                  ),
                  // Save and Search buttons positioned at the top-right of the scroll area.

                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Row(
                      children: [
                        MarkdownTooltip(
                          message: '''

                          **Search:** Tap here to search the R script for any
                          and all matching strings. The search is incremental,
                          finding matches as you type. The keyboard shortcut
                          `Ctrl-F` will also initiate a search.

                          ''',
                          child: IconButton(
                            icon: const Icon(Icons.search),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                _showSearchBar = true;
                              });
                              // Request focus for the search field immediately.

                              Future.delayed(Duration.zero, () {
                                _searchFocusNode.requestFocus();
                              });
                            },
                          ),
                        ),
                        const ScriptSaveButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle key events for shortcuts (e.g., Ctrl+F or Cmd+F to show search bar).

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
      final isControlPressed =
          keysPressed.contains(LogicalKeyboardKey.controlLeft) ||
              keysPressed.contains(LogicalKeyboardKey.controlRight);
      final isMetaPressed = keysPressed.contains(LogicalKeyboardKey.metaLeft) ||
          keysPressed.contains(LogicalKeyboardKey.metaRight);

      if ((isControlPressed || isMetaPressed) &&
          event.logicalKey == LogicalKeyboardKey.keyF) {
        setState(() {
          _showSearchBar = true;
        });
        // Move focus to the search field.

        Future.delayed(Duration.zero, () {
          _searchFocusNode.requestFocus();
        });
      }
    }
  }

  /// Build the search bar (shown at the top of the widget).

  Widget _buildSearchBar(BuildContext context, String script) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: Colors.white,
        child: Row(
          children: [
            // The search input.

            Expanded(
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search script...',
                  border: InputBorder.none,
                ),
                // Use onChanged so that the search happens immediately as the user types.

                onChanged: (query) {
                  _performSearch(query, script);
                },
              ),
            ),
            // Previous match button.

            IconButton(
              icon: const Icon(Icons.arrow_upward),
              tooltip: 'Previous match',
              onPressed: _matchIndices.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _currentMatchIndex =
                            (_currentMatchIndex - 1) % _matchIndices.length;
                        _scrollToMatch(script);
                      });
                    },
            ),
            // Next match button.

            IconButton(
              icon: const Icon(Icons.arrow_downward),
              tooltip: 'Next match',
              onPressed: _matchIndices.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _currentMatchIndex =
                            (_currentMatchIndex + 1) % _matchIndices.length;
                        _scrollToMatch(script);
                      });
                    },
            ),
            // Close search overlay button.

            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close search',
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchController.clear();
                  _matchIndices.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Find all occurrences of [query] in [script] and scroll to the first match.

  void _performSearch(String query, String script) {
    List<int> indices = [];
    if (query.isNotEmpty) {
      int startIndex = 0;
      while (true) {
        final index =
            script.toLowerCase().indexOf(query.toLowerCase(), startIndex);
        if (index == -1) break;
        indices.add(index);
        startIndex = index + query.length;
      }
    }
    setState(() {
      _matchIndices = indices;
      _currentMatchIndex = 0;
    });
    if (_matchIndices.isNotEmpty) {
      _scrollToMatch(script);
    }
  }

  /// Scroll to the match at [_matchIndices[_currentMatchIndex]].

  void _scrollToMatch(String script) {
    if (_matchIndices.isEmpty) return;
    final matchIndex = _matchIndices[_currentMatchIndex];
    // Calculate the line number where the match occurs.

    final textBeforeMatch = script.substring(0, matchIndex);
    final lineNumber = '\n'.allMatches(textBeforeMatch).length;
    final offset = lineNumber * _lineHeight;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

/// Build text spans highlighting matches of [query] in [text].
/// [matchIndices] contains the starting indices of each occurrence.
/// The match at the current index (specified by [currentMatchIndex])
/// is highlighted in other color.

List<TextSpan> buildHighlightSpans(
  String text,
  String query,
  List<int> matchIndices,
  int currentMatchIndex,
) {
  List<TextSpan> spans = [];
  if (query.isEmpty || matchIndices.isEmpty) {
    spans.add(TextSpan(text: text, style: monoSmallTextStyle));

    return spans;
  }
  int start = 0;
  final queryLength = query.length;

  // Iterate with an index so we know which match is the current one.

  for (int i = 0; i < matchIndices.length; i++) {
    final index = matchIndices[i];
    if (index > start) {
      spans.add(
        TextSpan(
          text: text.substring(start, index),
          style: monoSmallTextStyle,
        ),
      );
    }
    // Use green for the current match, yellow for others.

    Color highlightColor =
        (i == currentMatchIndex) ? Colors.lightGreen : Colors.yellow;
    spans.add(
      TextSpan(
        text: text.substring(index, index + queryLength),
        style: monoSmallTextStyle.copyWith(backgroundColor: highlightColor),
      ),
    );
    start = index + queryLength;
  }
  // Add any remaining text after the last match.

  if (start < text.length) {
    spans.add(
      TextSpan(text: text.substring(start), style: monoSmallTextStyle),
    );
  }

  return spans;
}
