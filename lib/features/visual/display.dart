/// Widget to display the VISUAL introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-07-14 19:47:59 +1000 Graham Williams>
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
    List<Widget> pages = [showMarkdownFile(visualIntroFile, context)];

    // List<String> lines = [];

    pages.add(
      ImagePage(
        title: 'Box Plot\n\n'
            'Generated using `ggplot2::geom_boxplot()`',
        path: '$tempDir/explore_visual_boxplot.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Histogram Plot\n\n'
            'Generated using `ggplot2::geom_density()`',
        path: '$tempDir/explore_visual_histogram.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Cummulative Plot\n\n'
            'Generated using `Hmisc::Ecdf()`',
        path: '$tempDir/explore_visual_cummulative.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Benford Plot\n\n'
            'Generated using `ggplot2`',
        path: '$tempDir/explore_visual_benford.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Pairs Plot\n\n'
            'Generated using `ggpairs`',
        path: '$tempDir/explore_visual_pairs.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Bar Chart\n\n'
            'Generated using `gplots::barplot2()`',
        path: '$tempDir/explore_visual_bars.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Dot Plot\n\n'
            'Generated using `dotchart()`',
        path: '$tempDir/explore_visual_dots.svg',
      ),
    );

    pages.add(
      ImagePage(
        title: 'Pairs Plot\n\n'
            'Generated using `mosaicplot()`',
        path: '$tempDir/explore_visual_mosaic.svg',
      ),
    );

    return Pages(
      children: pages,
    );
  }
}
