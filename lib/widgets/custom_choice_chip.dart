/// Chip choice widget used across the app.
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

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final String selectedTransform;
  final ValueChanged<bool> onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selectedTransform,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      disabledColor: Colors.grey,
      selectedColor: Colors.lightBlue[200],
      backgroundColor: Colors.lightBlue[50],
      shadowColor: Colors.grey,
      pressElevation: 8.0,
      elevation: 2.0,
      selected: selectedTransform == label,
      onSelected: onSelected,
    );
  }
}
