/// A widget for a labelled checkbox with  a tooltip updating the provider.
//
// Time-stamp: <Friday 2024-09-27 09:41:14 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:markdown_tooltip/markdown_tooltip.dart';

/// Custom LabelledCheckbox widget

class LabelledCheckbox extends ConsumerWidget {
  final String label;
  final String tooltip;
  final StateProvider<bool> provider;
  final bool enabled;
  final ValueChanged<bool?>? onSelected;

  const LabelledCheckbox({
    required this.label,
    required this.tooltip,
    required this.provider,
    this.enabled = true,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider for changes.

    final bool isChecked = ref.watch(provider);

    return MarkdownTooltip(
      message: tooltip,
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: enabled
                ? (value) {
                    // Update the provider's value.
                    ref.read(provider.notifier).state = value ?? false;
                    if (onSelected != null) {
                      onSelected!(value);
                    }
                  }
                : null,
          ),
          GestureDetector(
            onTap: () {
              // Toggle checkbox when the label is tapped.

              ref.read(provider.notifier).state = !isChecked;
              if (onSelected != null) {
                onSelected!(!isChecked);
              }
            },
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
