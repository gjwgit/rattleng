/// Chip choice widget used across the app.
//
// Time-stamp: <Saturday 2024-08-10 06:35:02 +1000 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu, Yixiang Yin

library;

import 'package:flutter/material.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/utils/word_wrap.dart';

class ChoiceChipTip<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) getLabel;
  final T selectedOption;
  final ValueChanged<T?> onSelected;
  final Map? tooltips;

  const ChoiceChipTip({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.tooltips,
    String Function(T)? getLabel,
  }) : getLabel = getLabel ?? _defaultGetLabel;

  static String _defaultGetLabel(option) => option.toString();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      runSpacing: choiceChipRowSpace,
      children: options.map((option) {
        final label = getLabel(option);

        return ChoiceChip(
          label: Text(label),
          tooltip: tooltips == null ? '' : wordWrap(tooltips![option] ?? ''),
          disabledColor: Colors.grey,
          selectedColor: Colors.lightBlue[200],
          backgroundColor: Colors.lightBlue[50],
          shadowColor: Colors.grey,
          pressElevation: 8.0,
          elevation: 2.0,
          selected: selectedOption == option,
          onSelected: (bool selected) {
            onSelected(selected ? option : null);
          },
        );
      }).toList(),
    );
  }
}
