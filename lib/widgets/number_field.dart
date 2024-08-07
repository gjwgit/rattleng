/// A numerical text input field.
//
// Time-stamp: <Sunday 2024-07-21 21:01:29 +1000 Graham Williams>
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

class NumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextStyle textStyle;
  final String tooltip;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputFormatter inputFormatter;
  final int maxWidth;
  final num interval; // Interval can be an int or double
  final int decimalPlaces;

  const NumberField({
    super.key,
    required this.label,
    required this.controller,
    required this.textStyle,
    required this.tooltip,
    required this.enabled,
    required this.validator,
    required this.inputFormatter,
    this.maxWidth = 5,
    this.decimalPlaces = 0,
    this.interval = 1, // Default interval is 1, can be set as double or int
  });

  void _increment() {
    // Parse the current value, increment by interval, and update the text field.
    num currentValue = num.tryParse(controller.text) ?? 0;
    currentValue += interval;
    controller.text = currentValue.toStringAsFixed(decimalPlaces);
  }

  void _decrement() {
    // Parse the current value, decrement by interval, and update the text field.
    num currentValue = num.tryParse(controller.text) ?? 0;
    currentValue -= interval;
    controller.text = currentValue.toStringAsFixed(decimalPlaces);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textStyle),
            SizedBox(
              width: maxWidth * 30.0,
              child: Stack(
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.only(
                        right: 40,
                        left: 10,
                      ),
                      errorText: validator(controller.text),
                      errorStyle: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: textStyle,
                    enabled: enabled,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      inputFormatter,
                    ],
                  ),
                  // Positioned Arrow Buttons.
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_up),
                          padding: EdgeInsets.zero, // Remove default padding
                          constraints:
                              const BoxConstraints(), // Remove default constraints
                          onPressed: enabled ? _increment : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          padding: EdgeInsets.zero, // Remove default padding
                          constraints:
                              const BoxConstraints(), // Remove default constraints
                          onPressed: enabled ? _decrement : null,
                        ),
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
}
