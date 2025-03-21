/// An R script text widget for the SCRIPT tab page.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-12-02 05:33:57 +1100 Graham Williams>
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

import 'package:rattle/constants/style.dart';
import 'package:rattle/constants/keys.dart';
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

  bool _showSearchBar = false;
  List<int> _matchIndices = [];
  int _currentMatchIndex = 0;
  // A rough assumption for line height (adjust if needed).

  final double _lineHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    // Retrieve the script from the provider.
    final script = ref.watch(scriptProvider);

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Main scrollable content.

            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: SelectableText(
                    script,
                    key: scriptTextKey,
                    style: monoSmallTextStyle,
                  ),
                ),
              ),
            ),
            // ScriptSaveButton at the top-right corner.

            Positioned(
              top: 8.0,
              right: 8.0,
              child: const ScriptSaveButton(),
            ),
            // Search bar overlay.

            if (_showSearchBar) _buildSearchBar(context, script),
          ],
        ),
      ),
    );
  }

  /// Listen for key events and trigger the search overlay if Ctrl+F (or Cmd+F) is pressed.

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
      final isControlPressed = keysPressed.contains(LogicalKeyboardKey.controlLeft) ||
          keysPressed.contains(LogicalKeyboardKey.controlRight);
      final isMetaPressed = keysPressed.contains(LogicalKeyboardKey.metaLeft) ||
          keysPressed.contains(LogicalKeyboardKey.metaRight);
      if ((isControlPressed || isMetaPressed) &&
          event.logicalKey == LogicalKeyboardKey.keyF) {
        setState(() {
          _showSearchBar = true;
        });
      }
    }
  }

  /// Build the search bar overlay.
  
  Widget _buildSearchBar(BuildContext context, String script) {
    return Positioned(
      top: 8.0,
      left: 8.0,
      right: 8.0,
      child: Material(
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
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search script...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
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
      ),
    );
  }

  /// Find all occurrences of [query] in [script] and scroll to the first match.
  
  void _performSearch(String query, String script) {
    List<int> indices = [];
    if (query.isNotEmpty) {
      int startIndex = 0;
      while (true) {
        final index = script.toLowerCase().indexOf(query.toLowerCase(), startIndex);
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
