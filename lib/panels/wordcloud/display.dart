/// Display for word cloud.
//
// Time-stamp: <Friday 2024-06-14 14:23:49 +1000 Graham Williams>
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
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';

class WordCloudDisplay extends ConsumerStatefulWidget {
  const WordCloudDisplay({super.key});
  @override
  ConsumerState<WordCloudDisplay> createState() => WordCloudDisplayState();
}

bool buildButtonPressed(String buildTime) {
  return buildTime.isNotEmpty;
}

class WordCloudDisplayState extends ConsumerState<WordCloudDisplay> {
  @override
  Widget build(BuildContext context) {
    // Build the word cloud widget to be displayed in the tab, consisting of the
    // top configuration and the main panel showing the generated image. Before
    // the build we display a introdcurory text to the functionality.
    List<Widget> pages = [
      showMarkdownFile(wordCloudMsgFile, context),
    ];

    // Reload the wordcloud image.

    imageCache.clear();
    imageCache.clearLiveImages();
    String lastBuildTime = ref.watch(wordCloudBuildProvider);
    debugPrint('received rebuild on $lastBuildTime');
    var wordCloudFile = File(wordCloudImagePath);

    // file exists | build not empty
    // 1 | 1 -> show the png
    // 1 | 0 -> show not built
    // 0 | 0 -> show not built
    // 0 | 1 -> show loading
    // build button pressed but png not exists (never reached)
    if (buildButtonPressed(lastBuildTime)) {
      // The check to see if file exists is not necessary.
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

      Widget imageDisplay = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
        ],
      );
      pages.add(
        SingleChildScrollView(
          child: imageDisplay,
        ),
      );
    }

    return Pages(children: pages);
  }
}
