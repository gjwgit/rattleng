/// Dropdown widget to select a variable.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: "Wednesday 2025-09-10 13:40:37 +1000 Graham Williams"
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
/// Authors: Graham Williams, Yixiang Yin, Kevin Wang, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

Widget variableChooser(
  String label,
  List<String> inputs,
  String selected,
  WidgetRef ref,
  StateProvider stateProvider, {
  // Add a parameter to control if the dropdown is enabled.

  required bool enabled,
  required String tooltip,

  // Add a callback for onChanged to handle custom logic.
  //
  // 20250910 gjw I removed this being an optional parameter to avoid dart code
  // metrics identiying unnecessary nullable since all calls provide a
  // function. But to do so I need to provide a default, which in this case does
  // nothing.

  required Function(String?) onChanged,
}) {
  return MarkdownTooltip(
    message: tooltip,
    child: DropdownMenu(
      label: Text(label),
      width: 200,
      initialSelection: selected,
      dropdownMenuEntries: inputs.map((s) {
        return DropdownMenuEntry(value: s, label: s);
      }).toList(),

      // Use the enabled parameter to control the dropdown state.
      enabled: enabled,
      onSelected: (String? value) {
        if (enabled) {
          ref.read(stateProvider.notifier).state = value ?? 'IMPOSSIBLE';
          onChanged(value);
        }
      },

      // Add a custom style for when it's disabled.
      textStyle: TextStyle(
        // Set grey when disabled.
        color: enabled ? Colors.black : Colors.grey,
      ),
    ),
  );
}
