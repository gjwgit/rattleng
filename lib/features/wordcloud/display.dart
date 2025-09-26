/// Display for word cloud.
//
// Time-stamp: "Monday 2025-05-12 09:59:26 +1000 Graham Williams"
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Yixiang Yin, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/wordcloud.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
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
    ); // Get the PageController from Riverpod.
    final stdout = ref.watch(stdoutProvider);
    final lastBuildTime = ref.watch(wordCloudBuildProvider);

    // Build the word cloud widget to be displayed in the tab, consisting of the
    // top configuration and the main panel showing the generated image. Before
    // the build we display a introdcurory text to the functionality.

    List<Widget> pages = [
      showMarkdownFile(context, wordCloudMsgFile, 'assets/svg/wordcloud.svg'),
    ];

    // file exists | build not empty
    // 1 | 1 -> show the png
    // 1 | 0 -> show not built
    // 0 | 0 -> show not built
    // 0 | 1 -> show loading
    // build button pressed but png not exists (never reached)
    if (buildButtonPressed(lastBuildTime)) {
      // The check to see if file exists is not necessary.
      // build button pressed and png file exists.

      pages.add(
        ImagePage(
          title: '''

          # Word Cloud

          Generated using
          [wordcloud::wordcloud()](https://www.rdocumentation.org/packages/wordcloud/topics/wordcloud).

          ''',
          path: wordCloudImagePath,
        ),
      );

      // Term Frequency Page.

      final String tfContentRaw = rExtract(
        stdout,
        'd %>% dplyr::filter(freq >=',
      );
      String tfContentDisplay;
      if (tfContentRaw.isNotEmpty) {
        tfContentDisplay = tfContentRaw.split('\n').skip(2).join('\n');
      } else {
        tfContentDisplay = '';
      }
      pages.add(
        TextPage(
          title: '''

          # Term Frequency

          Generated from a
          [tm::TermDocumentMatrix()](https://www.rdocumentation.org/packages/tm/topics/TermDocumentMatrix).

          The word frequency list below shows a maximum of
          ${ref.watch(maxWordProvider.notifier).state} words having a frequency
          of at least ${ref.watch(minFreqProvider.notifier).state}.

          ''',
          content: tfContentDisplay.isNotEmpty
              ? tfContentDisplay
              : 'Term frequencies are being processed or are not available.',
        ),
      );

      ////////////////////////////////////////////////////////////////////////

      String barChartImg = '$tempDir/word_frequency_barplot.svg';

      if (imageExists(barChartImg)) {
        pages.add(
          ImagePage(
            title: '''

          # Term Frequency Bar Chart

          ''',
            path: barChartImg,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String correlationImg = '$tempDir/model_wordcloud_cor.svg';

      if (imageExists(correlationImg)) {
        pages.add(
          ImagePage(
            title: '''

          # Term Correlation Plot

          Generated using
          [tm::findFreqTerms()](https://www.rdocumentation.org/packages/tm/topics/findFreqTerms) and
          [tm::plot()](https://www.rdocumentation.org/packages/tm/topics/plot).

          ''',
            path: correlationImg,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      // Term Association Page.

      final String taContentRaw = rExtract(stdout, '> tm::findAssocs(dtm,');
      String taContentDisplay;
      if (taContentRaw.isNotEmpty) {
        taContentDisplay = taContentRaw.split('\n').skip(1).join('\n');
      } else {
        taContentDisplay = '';
      }
      pages.add(
        TextPage(
          title: '''

          # Term Association

          Generated using
          [tm::findAssocs()](https://www.rdocumentation.org/packages/tm/topics/findAssocs).

          The list below shows terms associated with the chosen Cor Term
          '${ref.watch(textCorWordProvider.notifier).state}' with a correlation of
          at least ${ref.watch(textCorLimitProvider.notifier).state}.

          ''',
          content: taContentDisplay.isNotEmpty
              ? taContentDisplay
              : 'Term associations are being processed or are not available.',
        ),
      );

      ////////////////////////////////////////////////////////////////////////
    } // This closes the if (buildButtonPressed(lastBuildTime)) block

    return PageViewer(pageController: pageController, pages: pages);
  }
}
