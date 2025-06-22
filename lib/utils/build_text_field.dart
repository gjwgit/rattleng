/// Build a text field widget for the input of numeric values.
//
// Time-stamp: <Monday 2025-06-23 08:03:17 +1000 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Zheyuan Xu, Graham Williams

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/providers/forest.dart';

/// Create a custom filed for entering numeric values.
///
/// A [TextFormField] with a [label] is wrapped within a MarkdownTooltip to
/// support our standard [tooltip] widget. The field has a specified [textStyle]
/// with configurable [maxWidth], an [inputFormatter], and [validator] rules.

class buildTextField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextStyle textStyle;
  final String tooltip;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputFormatter inputFormatter;
  final int maxWidth;
  final WidgetRef? ref;
  final VoidCallback? onUpDownPressed;
  final int? tapDelay;

  const buildTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.textStyle,
    required this.tooltip,
    required this.enabled,
    required this.validator,
    required this.inputFormatter,
    required this.maxWidth,
    required this.ref,
    this.onUpDownPressed,
    this.tapDelay,
  });

  @override
  ConsumerState<buildTextField> createState() => _buildTextFieldState();
}

class _buildTextFieldState extends ConsumerState<buildTextField> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextFieldChanged(String value) {
    _debounceTimer?.cancel();
    if (widget.onUpDownPressed != null) {
      _debounceTimer = Timer(
        Duration(milliseconds: widget.tapDelay ?? 500),
        () {
          if (mounted) {
            widget.onUpDownPressed!();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: MarkdownTooltip(
        message: widget.tooltip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.maxWidth * 15.0,
              child: TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: widget.label,
                  border: const UnderlineInputBorder(),
                  errorText: widget.validator(widget.controller.text),
                  errorStyle: const TextStyle(fontSize: 10),
                ),
                style: widget.textStyle,
                enabled: widget.enabled,
                inputFormatters: [
                  widget.inputFormatter,
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                onChanged: _onTextFieldChanged,
                // TODO 20250623 gjw Why do we need a special case for Sample Size?
                //
                // This is particularly bad practice, having a special case for
                // a single text field for just one part of the user
                // interface. @zheyuan, we need to have a really good
                // explanation here for this please. Or else implement the
                // special case through extra parameters.
                onEditingComplete: () {
                  if (widget.label == 'Sample Size:' && widget.ref != null) {
                    ref.read(forestSampleSizeProvider.notifier).state =
                        widget.controller.text;
                  }
                },
                onSaved: (value) {
                  if (widget.label == 'Sample Size:' && widget.ref != null) {
                    ref.read(forestSampleSizeProvider.notifier).state =
                        widget.controller.text;
                  }
                },
                onTapOutside: (event) {
                  if (widget.label == 'Sample Size:' && widget.ref != null) {
                    ref.read(forestSampleSizeProvider.notifier).state =
                        widget.controller.text;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
