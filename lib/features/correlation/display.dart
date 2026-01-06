/// Rattle - Data Science Next Generation
///
// Time-stamp: "Tuesday 2026-01-06 14:05:53 +1100 Graham Williams"
///
/// Copyright (C) 2024-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
///
/// https://opensource.org/license/gpl-3-0
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/text_page.dart';

/// Widget to display the CORRELATION introduction or output.

class CorrelationDisplay extends ConsumerStatefulWidget {
  const CorrelationDisplay({super.key});

  @override
  ConsumerState<CorrelationDisplay> createState() => _CorrelationDisplayState();
}

class _CorrelationDisplayState extends ConsumerState<CorrelationDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      correlationPageControllerProvider,
    ); // Get the PageController from Riverpod

    String stdout = ref.watch(stdoutProvider);
    List<Widget> pages = [showMarkdownFile(correlationIntroFile, context)];

    String content = '';
    String image = '';
    List<String> lines = [];

    ////////////////////////////////////////////////////////////////////////
    // GGDENDRO
    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_correlation_ggdendro.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Dendrogram Showing Correlations

        The length of the lines in the dendrogram provide a visual indication of
        the degree of correlation.

        Shorter lines indicate more tighly correlated variables.

        Generated using
        [ggdendro::ggdenrogram()](https://www.rdocumentation.org/packages/ggdendro/topics/ggdendrogram).

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // CORRPLOT
    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_correlation.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Variable Correlation Plot

        Visit the [Survival
        Guide](https://survivor.togaware.com/datascience/correlated-numeric-variables.html)
        and
        [corrplot::corrplot(ds)](https://www.rdocumentation.org/packages/corrplot/topics/corrplot)

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // GGCORRPLOT
    ////////////////////////////////////////////////////////////////////////
    //
    // 20250419 gjw. An SVG image displays a black box in the app. The display
    // of it using the external viewer is just fine. The problem is the
    // unhandled element <filter/> for the SVG loader. So we pass both the SVG
    // and the PNG until in R we identify a SVG generation that does not use the
    // filter element.

    String imageSVG = '$tempDir/explore_correlation_ggcorrplot.svg';
    String imagePNG = '$tempDir/explore_correlation_ggcorrplot.png';

    if (imageExists(imagePNG)) {
      pages.add(
        ImagePage(
          title: '''

          # GGPlot Correlation

          Generated using
          [ggcorrplot::ggcorrplot(ds)](https://www.rdocumentation.org/packages/ggcorrplot/topics/ggcorrplot).

          ''',
          path: imageSVG,
          display: imagePNG,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // COR
    ////////////////////////////////////////////////////////////////////////

    // 20250222 gjw Trying to get a properly aligned output for Windows. There
    // are some odd formatting happening from Windows, and we have not yet
    // resolved the issue.

    // content = rExtract(stdout, 'print(round(cor,2))');
    content = rExtract(stdout, 'print(format(round(corm');
    // content = rExtract(stdout, 'knitr::kable(round(cor, 2))');

    // Add a blank line between each sub-table.

    lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('  ')) {
        lines[i] = '\n${lines[i]}';
      }
    }

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Correlation - Numeric Data

          Here are the actual calculated correlations that the visualisations
          are based on.

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/correlated-numeric-variables.html)
          and
          [stats::cor()](https://www.rdocumentation.org/packages/stats/topics/cor)

          ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(pageController: pageController, pages: pages);
  }
}
