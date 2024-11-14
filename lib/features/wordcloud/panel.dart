/// Wordcloud Display()
//
// Time-stamp: <Friday 2024-06-14 10:05:29 +1000 Graham Williams>
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

import 'package:flutter/material.dart';
import 'package:rattle/constants/spacing.dart';

import 'package:rattle/features/wordcloud/config.dart';
import 'package:rattle/features/wordcloud/display.dart';

class WordCloudPanel extends StatelessWidget {
  const WordCloudPanel({super.key});
  @override
  Widget build(BuildContext context) {
    // A per the RattleNG pattern, a Tab consists of a Config bar and the
    // results Display().

    return const Scaffold(
      body: Column(
        children: [
          // TODO 20240605 gjw NOT QUIT THE RIGHT SOLUTION YET. IF I SET MAX
          // WORDS TO 10 WHILE THE MSG IS DISPLAYED THEN BUILD, IT GET THE
          // PARAMETER BUT AFTER THE BUILD/REFRESH THE 10 IS LOST FROM THE
          // CONFIG BAR SINCE IT IS REBUILT. HOW TO FIX THAT AND RETAIN THE
          // MESSAGE WITHTHE CONFIG BAR.
          WordCloudConfig(),

          // Add a little space below the underlined input widget so the
          // underline is not lost. Thouoght to include this in config but then
          // I would need an extra Column widget(). Seems okay logically to add
          // the spacer here as part of the tab.

          panelGap,
          // TODO 20240605 gjw THIS FUNCTIONALITY TO MIGRATE TO THE APP SAVE
          // BUTTON TOP RIGHT. KEEP HERE AS A COMMENT UNTIL IMPLEMENTED.
          //
          // WordCloudSaveButton(
          //  wordCloudImagePath: wordCloudImagePath,
          // ),

          // A text view that takes up the remaining space and displays the
          // Rattle welcome and getting started message. This will be
          // overwritten once a dataset is loaded.

          Expanded(
            child: WordCloudDisplay(),
          ),
        ],
      ),
    );
  }
}
