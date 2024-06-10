/// Wordcloud Tab
//
// Time-stamp: <Monday 2024-06-10 10:34:53 +1000 Graham Williams>
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
/// Authors: Yixiang Yin, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/colors.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/features/model/wordcloud/config.dart';
import 'package:rattle/features/model/wordcloud/panel.dart';
import 'package:rattle/provider/wordcloud/build.dart';
import 'package:rattle/widgets/markdown_file.dart';

class WordCloudTab extends StatelessWidget {
  const WordCloudTab({super.key});
    @override
  Widget build(BuildContext context) {
    // A per the RattleNG pattern, a Tab consists of a Config bar and the
    // results Panel.

    return const Scaffold(
      body: Column(
        children: [
          WordCloudConfig(),

          // Add a little space below the underlined input widget so the
          // underline is not lost. Thouoght to include this in config but then
          // I would need an extra Column widget(). Seems okay logically to add
          // the spacer here as part of the tab.

          SizedBox(height: 10),

          // A text view that takes up the remaining space and displays the
          // Rattle welcome and getting started message. This will be
          // overwritten once a dataset is loaded.

          WordCloudPanel(),
        ],
      ),
    );
  }
}