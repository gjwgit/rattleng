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
import 'package:rattle/constants/app.dart';

import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/widgets/show_markdown_file.dart';

class WordCloudDisplay extends ConsumerStatefulWidget {
  const WordCloudDisplay({super.key});
  @override
  ConsumerState<WordCloudDisplay> createState() => _WordCloudDisplayState();
}

bool buildButtonPressed(String buildTime) {
  return buildTime.isNotEmpty;
}

// TODO yyx 20240626 make 2 panes, the first one display the intro file and the second one is the wordcloud png
class _WordCloudDisplayState extends ConsumerState<WordCloudDisplay> {
  late PageController _pageController;
  int _currentPage = 0;
  // number of pages available
  int numPages = 2;
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < numPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    // Build the word cloud widget to be displayed in the tab, consisting of the
    // top configuration and the main panel showing the generated image. Before
    // the build we display a introdcurory text to the functionality.
    final curHeight = MediaQuery.of(context).size.height;
    Widget? imageDisplay;

    // Reload the wordcloud image.

    imageCache.clear();
    imageCache.clearLiveImages();
    String lastBuildTime = ref.watch(wordCloudBuildProvider);
    debugPrint('received rebuild on $lastBuildTime');
    var wordCloudFile = File(wordCloudImagePath);

    // Identify a widget for the display of the word cloud image file. Default
    // to a BUG display! The traditional 'This should not happen'.

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

      imageDisplay = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
        ],
      );
    }

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_left,
            color: _currentPage > 0 ? Colors.black : Colors.grey,
            size: 32,
          ),
          onPressed: _currentPage > 0 ? _goToPreviousPage : null,
        ),
        Expanded(
          child: SizedBox(
            height: curHeight * displayRatio,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                showMarkdownFile(wordCloudMsgFile, context),
                Container(
                  decoration: sunkenBoxDecoration,
                  child: buildButtonPressed(lastBuildTime)
                      ? SingleChildScrollView(
                          child: imageDisplay,
                        )
                      : const Center(
                          child:
                              Text('Click the build button to see the result'),
                        ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_right,
            size: 32,
            color: _currentPage < numPages - 1 ? Colors.black : Colors.grey,
          ),
          onPressed: _currentPage < numPages - 1 ? _goToNextPage : null,
        ),
      ],
    );
  }
}
