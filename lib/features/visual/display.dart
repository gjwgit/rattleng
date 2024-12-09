/// Widget to display the VISUAL introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-11-19 09:24:25 +1100 Graham Williams>
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
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/single_image_page.dart';

/// The panel displays the instructions or the output.

class VisualDisplay extends ConsumerStatefulWidget {
  const VisualDisplay({super.key});

  @override
  ConsumerState<VisualDisplay> createState() => _VisualDisplayState();
}

class _VisualDisplayState extends ConsumerState<VisualDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      visualPageControllerProvider,
    ); // Get the PageController from Riverpod

    List<Widget> pages = [showMarkdownFile(visualIntroFile, context)];

    // 20240817 gjw We watch changes to stdout as a clue that we need to rebuild
    // this widget.

    ref.watch(stdoutProvider);

    String selected = ref.watch(selectedProvider.notifier).state;

    Type? stype = ref.read(typesProvider.notifier).state[selected];

    String image = '';

    if (stype == Type.numeric) {
      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_boxplot.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Box Plot

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/box-plot.html) and
          [ggplot2::geom_boxplot()](https://www.rdocumentation.org/packages/ggplot2/topics/geom_boxplot).

              ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_density.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Density Plot of Values

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/density-plot.html) and
          [ggplot2::geom_density()](https://www.rdocumentation.org/packages/ggplot2/topics/geom_density).

          ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_ecdf.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Cumulative Plot

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/cumulative-plot.html) and
          [ggplot2::stat_ecdf()](https://www.rdocumentation.org/packages/ggplot2/topics/stat_ecdf).

          ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_benford.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Benford Plot

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/benford-plot.html) and
          [rattle::plotDigitFreq()](https://www.rdocumentation.org/packages/rattle).

          ''',
            path: image,
          ),
        );
      }
    }

    // If two variables selected then we can do a pairs plot.

    // pages.add(
    //   SingleImagePage(
    //     title: 'Pairs Plot\n\n'
    //         'Generated using [GGally::ggpairs()]'
    //         '(https://www.rdocumentation.org/packages/GGally/topics/ggpairs).',
    //     path: '$tempDir/explore_visual_pairs.svg',
    //   ),
    // );

    if (stype == Type.categoric) {
      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_bars.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Bar Chart

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/bar-chart.html) and
          [gplots::barplot2()](https://www.rdocumentation.org/packages/gplots/topics/barplot2).

          ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_mosaic.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Mosaic Plot

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/mosaic-plot.html) and
          [graphics::mosaicplot()](https://www.rdocumentation.org/packages/graphics/topics/mosaicplot).

          ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/explore_visual_dots.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

          # Dot Plot

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/dot-plot.html) and
          [graphics::dotchart()](https://www.rdocumentation.org/packages/graphics/topics/dotchart).

          ''',
            path: image,
          ),
        );
      }
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
