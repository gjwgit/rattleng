/// A single input field of the INTERACTIVE prediction popup.
///
/// Time-stamp: "Saturday 2026-08-15 10:12:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:rattle/features/evaluate/interactive_variable.dart';

/// The field through which the user gives [variable] a value.
///
/// A categoric variable is a dropdown of the levels it takes in the dataset, so
/// that a level the model has never seen cannot be entered. Anything else is a
/// text field, driven by a [controller] owned by the popup so that typing does
/// not rebuild the field and take the keyboard focus with it.

class InteractiveField extends StatelessWidget {
  final InteractiveVariable variable;
  final String value;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  const InteractiveField({
    super.key,
    required this.variable,
    required this.value,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              variable.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: variable.isCategoric
                ? DropdownButtonFormField<String>(
                    // A value the dataset does not have would not be in the
                    // list, and so would throw, hence fall back to no
                    // selection.

                    initialValue:
                        variable.levels.contains(value) ? value : null,
                    isDense: true,
                    decoration: const InputDecoration(isDense: true),
                    items: variable.levels
                        .map(
                          (level) => DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                    onChanged: (chosen) {
                      if (chosen != null) onChanged(chosen);
                    },
                  )
                : TextFormField(
                    controller: controller,
                    keyboardType: variable.isNumeric
                        ? const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          )
                        : TextInputType.text,
                    decoration: const InputDecoration(isDense: true),
                    onChanged: onChanged,
                  ),
          ),
        ],
      ),
    );
  }
}
