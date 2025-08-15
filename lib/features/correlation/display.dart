/// Rattle - Data Science Next Generation
///
// Time-stamp: "Tuesday 2025-08-05 16:44:19 +1000 Graham Williams"
///
/// Copyright (C) 2024-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
///
/// https://www.gnu.org/licenses/gpl-3.0.en.html
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
    // COR
    ////////////////////////////////////////////////////////////////////////

    // 20250222 gjw Trying to get a properly aligned output for Windows. There
    // are some odd formatting happening from Windows, and we have not yet
    // resolved the issue.

    // content = rExtract(stdout, 'print(round(cor,2))');
    content = rExtract(stdout, 'print(format(round(corm, 2)');
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
    // The **svg** only displays a black box in the app. The display of it using
    // the external viewer is just fine. The problem is the unhandled element
    // <filter/> for the Svg loader. So we pass both the **svg** and the
    // **png**.  20250419 gjw.

    String imageSVG = '$tempDir/explore_correlation_ggcorrplot.svg';
    String imagePNG = '$tempDir/explore_correlation_ggcorrplot.png';

    if (imageExists(imagePNG)) {
      pages.add(
        ImagePage(
          title: '''

        # GGPlot Correlation

        Generated using
        [ggcorrplot::ggcorrplot(ds)](https://www.rdocumentation.org/packages/ggcorrplot/topics/ggcorrplot).

        To view this correlation plot please tap the **Open** button to the
        right. Our current SVG viewer does not support all SVG features.

        ''',
          path: imageSVG,
          display: imagePNG,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // GGDENDRO
    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_correlation_ggdendro.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # GGPlot Dendrogram

        Generated using
        [ggdendro::ggdenrogram()](https://www.rdocumentation.org/packages/ggdendro/topics/ggdendrogram).

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(pageController: pageController, pages: pages);
  }
}
