/// Panel for word cloud.
//
// Time-stamp: <Thursday 2024-06-06 05:58:50 +1000 Graham Williams>
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

import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/features/model/tab.dart';
import 'package:rattle/features/model/wordcloud/config.dart';
import 'package:rattle/provider/wordcloud/build.dart';
import 'package:rattle/widgets/markdown_file.dart';

class WordCloudTab extends ConsumerStatefulWidget {
  const WordCloudTab({super.key});
  @override
  ConsumerState<WordCloudTab> createState() => _WordCloudTabState();
}

bool buildButtonPressed(String buildTime) {
  return buildTime.isNotEmpty;
}

class _WordCloudTabState extends ConsumerState<WordCloudTab> {
  @override
  Widget build(BuildContext context) {
    // Build the word cloud widget to be displayed in the tab, consisting of the
    // top configuration and the main panel showing the generated image. Before
    // the build we display a introdcurory text to the functionality.

    // Reload the wordcloud image.

    imageCache.clear();
    imageCache.clearLiveImages();
    String lastBuildTime = ref.watch(wordCloudBuildProvider);
    debugPrint('received rebuild on $lastBuildTime');
    var wordCloudFile = File(wordCloudImagePath);
    bool fileExists = wordCloudFile.existsSync();

    // Identify a widget for the display of the word cloud image file. Default
    // to a BUG display! The traditional 'This should not happen'.

    Widget imageDisplay = const Text('This should not happen.');
    // file exists | build not empty
    // 1 | 1 -> show the png
    // 1 | 0 -> show not built
    // 0 | 0 -> show not built
    // 0 | 1 -> show loading
    if (buildButtonPressed(lastBuildTime)) {
      if (fileExists) {
        // build button pressed and png file exists
        debugPrint('Model built. Now Sleeping as needed to await file.');

        // Reload the image:
        // https://nambiarakhilraj01.medium.com/
        // what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca

        var bytes = wordCloudFile.readAsBytesSync();

        // TODO 20240601 gjw WITHOUT A DELAY HERE WE SEE AN EXCEPTION ON LINUX
        //
        // _Exception was thrown resolving an image codec:
        // Exception: Invalid image data
        //
        // ON PRINTING bytes WE SEE AN EMPYT LIST OF BYTES UNTIL THE FILE IS
        // LOADED SUCCESSFULLY.
        //
        // WITH THE SLEEP WE AVOID IT. SO WE SLEEP LONG ENOUGH FOR THE FILE THE BE
        // SUCCESSFULLY LOADED (BECUSE IT IS NOT YET WRITTEN?) SO WE NEED TO WAIT
        // UNTIL THE FILE IS READY.
        //
        // THERE MIGHT BE A BETTER WAY TO DO THIS - WAIT SYNCHRONLOUSLY?

        while (bytes.lengthInBytes == 0) {
          sleep(const Duration(seconds: 1));
          bytes = wordCloudFile.readAsBytesSync();
        }

        Image image = Image.memory(bytes);

        // Build the widget to display the image. Make it a row, centering the
        // image horizontally, and so ensuring the scrollbar is all the way to the
        // right.

        imageDisplay = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
          ],
        );
      } else {
        // build button pressed but png not exists
        imageDisplay = const Column(
          children: [
            SizedBox(height: 50),
            Text('Loading'),
          ],
        );
      }
    } else {
      // build button not pressed
      // If there is no image built then return a widget that displays the word
      // cloud introductory message, but with the config bar also displayed.
      debugPrint('No model has been built.');

      return Column(
        children: [
          // TODO 20240605 gjw NOT QUIT THE RIGHT SOLUTION YET. IF I SET MAX
          // WORDS TO 10 WHILE THE MSG IS DISPLAYED THEN BUILD, IT GET THE
          // PARAMETER BUT AFTER THE BUILD/REFRESH THE 10 IS LOST FROM THE
          // CONFIG BAR SINCE IT IS REBUILT. HOW TO FIX THAT AND RETAIN THE
          // MESSAGE WITHTHE CONFIG BAR.
          const WordCloudConfig(),
          Expanded(
            child: Center(
              child: sunkenMarkdownFileBuilder(wordCloudMsgFile),
            ),
          ),
        ],
      );
    }

    return wordCloudPanel(imageDisplay);
  }
}

Widget wordCloudPanel(Widget wordCloudBody) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        const WordCloudConfig(),

        // TODO 20240605 gjw THIS FUNCTIONALITY TO MIGRATE TO THE APP SAVE
        // BUTTON TOP RIGHT. KEEP HERE AS A COMMENT UNTIL IMPLEMENTED.
        //
        // WordCloudSaveButton(
        //  wordCloudImagePath: wordCloudImagePath,
        // ),

        const SizedBox(height: 10),

        Expanded(
          child: SingleChildScrollView(
            child: wordCloudBody,
          ),
        ),
      ],
    ),
  );
}
