/// Widget to display the VISUAL introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-07-23 12:47:01 +1000 Graham Williams>
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
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/show_markdown_file.dart';

/// The panel displays the instructions or the output.

class VisualDisplay extends ConsumerStatefulWidget {
  const VisualDisplay({super.key});

  @override
  ConsumerState<VisualDisplay> createState() => _VisualDisplayState();
}

class _VisualDisplayState extends ConsumerState<VisualDisplay> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(visualIntroFile, context)];

    // List<String> lines = [];

    String selected = ref.watch(selectedProvider.notifier).state;
    String numc = rExtract(stdout, '+ numc');
    bool numeric = numc.contains('"$selected"');

    if (numeric) {
      pages.add(
        ImagePage(
          title: 'Box Plot\n\n'
              'Generated using [ggplot2::geom_boxplot()]'
              '(https://www.rdocumentation.org/packages/ggplot2/topics/geom_boxplot).',
          path: '$tempDir/explore_visual_boxplot.svg',
        ),
      );

      pages.add(
        ImagePage(
          title: 'Histogram Plot\n\n'
              'Generated using [ggplot2::geom_density()]'
              '(https://www.rdocumentation.org/packages/ggplot2/topics/geom_density).',
          path: '$tempDir/explore_visual_histogram.svg',
        ),
      );

      pages.add(
        ImagePage(
          title: 'Cummulative Plot\n\n'
              'Generated using [Hmisc::Ecdf()]'
              '(https://www.rdocumentation.org/packages/Hmisc/topics/Ecdf).',
          path: '$tempDir/explore_visual_cummulative.svg',
        ),
      );

      pages.add(
        ImagePage(
          title: 'Benford Plot\n\n'
              'Generated using [rattle::plotDigitFreq()]'
              '(https://www.rdocumentation.org/packages/rattle).',
          path: '$tempDir/explore_visual_benford.svg',
        ),
      );
    }

    // If two variables selected then we can do a pairs plot.

    // pages.add(
    //   ImagePage(
    //     title: 'Pairs Plot\n\n'
    //         'Generated using [GGally::ggpairs()]'
    //         '(https://www.rdocumentation.org/packages/GGally/topics/ggpairs).',
    //     path: '$tempDir/explore_visual_pairs.svg',
    //   ),
    // );

    if (!numeric) {
      pages.add(
        ImagePage(
          title: 'Bar Chart\n\n'
              'Generated using [gplots::barplot2()]'
              '(https://www.rdocumentation.org/packages/gplots/topics/barplot2).',
          path: '$tempDir/explore_visual_bars.svg',
        ),
      );

      pages.add(
        ImagePage(
          title: 'Dot Plot\n\n'
              'Generated using [graphics::dotchart()]'
              '(https://www.rdocumentation.org/packages/graphics/topics/dotchart).',
          path: '$tempDir/explore_visual_dots.svg',
        ),
      );

      pages.add(
        ImagePage(
          title: 'Pairs Plot\n\n'
              'Generated using [graphics::mosaicplot()]'
              '(https://www.rdocumentation.org/packages/graphics/topics/mosaicplot).',
          path: '$tempDir/explore_visual_mosaic.svg',
        ),
      );
    }

    return Pages(
      children: pages,
    );
  }
}
