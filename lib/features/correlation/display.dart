/// Widget to display the CORRELATION introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-09-06 16:43:07 +1000 Graham Williams>
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
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

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

    content = rExtract(stdout, 'print(round(cor,2))');

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

    image = '$tempDir/explore_correlation.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          titles: [
            '''

        # Variable Correlation Plot
        
          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/correlated-numeric-variables.html)
          and
          [corrplot::corrplot(ds)](https://www.rdocumentation.org/packages/corrplot/topics/corrplot)

        '''
          ],
          paths: [image],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // GGCORRPLOT
    ////////////////////////////////////////////////////////////////////////
    //
    // 20240815 gjw This only displays a black box in the app? The display of it
    // using the external viewer is just fine?

    // pages.add(
    //   ImagePage(
    //     title: '''

    //     # GGPlot Correlation

    //     Generated using [ggcorrplot::ggcorrplot(ds)](https://www.rdocumentation.org/packages/ggcorrplot/topics/ggcorrplot)

    //     ''',
    //     path: '$tempDir/explore_correlation_ggcorrplot.svg',
    //   ),
    // );

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
