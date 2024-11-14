/// Dataset tab.
///
/// Time-stamp: <Saturday 2024-09-21 18:30:45 +1000 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
import 'package:rattle/constants/spacing.dart';

import 'package:rattle/features/dataset/config.dart';
import 'package:rattle/features/dataset/display.dart';

/// The dataset tab introduces RattleNG and supports loading a dataset.

class DatasetPanel extends StatelessWidget {
  const DatasetPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // A per the RattleNG pattern, a Tab consists of a Config bar and the
    // results Panel.

    return const Scaffold(
      body: Column(
        children: [
          DatasetConfig(),

          // Add a little space below the underlined input widget so the
          // underline is not lost. Thought to include this in config but then
          // I would need an extra Column widget(). Seems okay logically to add
          // the spacer here as part of the tab.

          panelGap,

          // A text view that takes up the remaining space and displays the
          // Rattle welcome and getting started message. This will be
          // overwritten once a dataset is loaded.

          Expanded(
            child: DatasetDisplay(),
          ),
        ],
      ),
    );
  }
}
