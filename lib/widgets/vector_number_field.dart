/// An integer vector input field.
//
// Time-stamp: <Wednesday 2024-10-16 09:54:03 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/style.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

class VectorNumberField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final StateProvider<String> stateProvider;
  final String tooltip;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputFormatter inputFormatter;
  final int maxWidth;

  const VectorNumberField({
    super.key,
    required this.controller,
    required this.stateProvider,
    required this.validator,
    required this.inputFormatter,
    this.label = '',
    this.tooltip = '',
    this.enabled = true,
    this.maxWidth = 5,
  });

  @override
  VectorNumberFieldState createState() => VectorNumberFieldState();
}

class VectorNumberFieldState extends ConsumerState<VectorNumberField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.text =
        ref.read(widget.stateProvider); // Initialize with state as a string
  }

  void updateField() {
    String updatedText = widget.controller.text.trim();

    // Parse the input: single integer or vector of integers.

    List<String> values = updatedText.split(RegExp(r',\s*'));

    List<int>? parsedValues = values
        .map((e) => int.tryParse(e))
        .where((e) => e != null)
        .cast<int>()
        .toList();

    if (parsedValues.isEmpty) {
      // If invalid input, leave the field as is.

      widget.controller.text = updatedText;
      ref.read(widget.stateProvider.notifier).state = updatedText;
    } else {
      // Update the text field and provider state with parsed values as a string.

      widget.controller.text = parsedValues.join(',');
      ref.read(widget.stateProvider.notifier).state = widget.controller.text;
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      updateField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownTooltip(
      message: widget.tooltip,
      child: SizedBox(
        width: widget.maxWidth * 30.0,
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const UnderlineInputBorder(),
            contentPadding: const EdgeInsets.only(right: 40, left: 10),
            errorText: widget.validator(widget.controller.text),
            errorStyle: const TextStyle(fontSize: 10),
          ),
          keyboardType: TextInputType.text,
          onEditingComplete: () {
            updateField();
          },
          style: widget.enabled ? normalTextStyle : disabledTextStyle,
          enabled: widget.enabled,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
            widget.inputFormatter,
          ],
        ),
      ),
    );
  }
}

// Example validation function for the vector.

String? validateVector(String? value) {
  if (value == null || value.isEmpty) return 'Cannot be empty';

  List<String> values = value.split(RegExp(r',\s*'));
  for (var val in values) {
    if (int.tryParse(val) == null) {
      return 'Invalid number';
    }
  }

  return null;
}
