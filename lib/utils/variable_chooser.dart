/// Dropdown Widget to select a variable
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-08-04 07:46:33 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget variableChooser(
  String label,
  List<String> inputs,
  String selected,
  WidgetRef ref,
  StateProvider stateProvider, {
  required bool
      enabled, // Add this parameter to control if the dropdown is enabled
  Function(String?)?
      onChanged, // Add a callback for onChanged to handle custom logic
}) {
  return DropdownMenu(
    label: Text(label),
    width: 200,
    initialSelection: selected,
    dropdownMenuEntries: inputs.map((s) {
      return DropdownMenuEntry(value: s, label: s);
    }).toList(),
    enabled: enabled, // Use the enabled parameter to control the dropdown state
    onSelected: (String? value) {
      if (enabled) {
        ref.read(stateProvider.notifier).state = value ?? 'IMPOSSIBLE';
        if (onChanged != null) {
          onChanged(value); // Call the custom callback if provided
        }
      }
    },
  );
}
