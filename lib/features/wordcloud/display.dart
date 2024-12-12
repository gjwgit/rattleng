/// Display for word cloud.
//
// Time-stamp: <Thursday 2024-09-26 18:42:41 +1000 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/single_image_page.dart';
import 'package:rattle/widgets/text_page.dart';

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
    final pageController = ref.watch(
      wordcloudPageControllerProvider,
    ); // Get the PageController from Riverpod
    String stdout = ref.watch(stdoutProvider);

    // Build the word cloud widget to be displayed in the tab, consisting of the
    // top configuration and the main panel showing the generated image. Before
    // the build we display a introdcurory text to the functionality.

    List<Widget> pages = [showMarkdownFile(wordCloudMsgFile, context)];

    String content = '';

    String lastBuildTime = ref.watch(wordCloudBuildProvider);

    // file exists | build not empty
    // 1 | 1 -> show the png
    // 1 | 0 -> show not built
    // 0 | 0 -> show not built
    // 0 | 1 -> show loading
    // build button pressed but png not exists (never reached)
    if (buildButtonPressed(lastBuildTime)) {
      // The check to see if file exists is not necessary.
      // build button pressed and png file exists

      pages.add(
        SingleImagePage(
          title: '# Word Cloud\n\n'
              'Generated using `wordcloud::wordcloud()`',
          path: wordCloudImagePath,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'd %>% filter(freq >=');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Word Frequency\n\n'
              'Generated using `TermDocumentMatrix()`',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
