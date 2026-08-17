/// Widget to display the MISSING introduction and display output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Tuesday 2026-08-18 06:07:16 +1000 Graham Williams"
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
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class MissingDisplay extends ConsumerStatefulWidget {
  const MissingDisplay({super.key});

  @override
  ConsumerState<MissingDisplay> createState() => _MissingDisplayState();
}

class _MissingDisplayState extends ConsumerState<MissingDisplay> {
  @override
  Widget build(BuildContext context) {
    // Get the PageController from Riverpod.

    final pageController = ref.watch(missingPageControllerProvider);

    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [
      showMarkdownFile(context, missingIntroFile, 'assets/svg/missing.svg'),
    ];

    String content = '';
    String image = '';
    List<String> lines = [];

    ////////////////////////////////////////////////////////////////////////
    // COUNT OF MISSING VALUES - TEXTUAL
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'VIM::aggr(');

    // 20251001 gjw On occasion VIM::aggr(), which also generates a plot using
    // VIM::plot.aggr(), emits a warning:
    //
    // Warning message:
    // In plot.aggr(res, ...) :
    //   not enough vertical space to display frequencies (too many combinations)
    //
    // Remove the warning from the textual summary. And then otherwise ignore it
    // for now, though in principle it should have a message on the
    // explore_missing_vim.svg page.

    content = content.split('Warning message:')[0];

    // Remove the line beginning with + (a continuation)

    lines = content.split('\n');

    lines = lines.where((line) => !line.startsWith('+')).toList();

    // Rejoin the lines.

    content = lines.join('\n');

    // 20260817 gjw Tidy the layout of what VIM prints. It begins with a blank
    // line, which lands on top of the blank line that ends the title above and
    // leaves the report floating well below its heading, and it runs its own
    // "Variables sorted by ..." heading straight into the table, where a blank
    // line between the two reads far better.

    lines = content.split('\n');

    while (lines.isNotEmpty && lines.first.trim().isEmpty) {
      lines.removeAt(0);
    }

    final int heading =
        lines.indexWhere((line) => line.contains('sorted by number of'));

    if (heading >= 0) lines.insert(heading + 1, '');

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Count of Missing Values - Textual

          Generated using
          [VIM::aggr(ds)](https://www.rdocumentation.org/packages/VIM/topics/aggr).

          ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // COMPARISON OF COUNTS OF MISSING VALUES
    ////////////////////////////////////////////////////////////////////////

    // 20260818 gjw This sits beside the count of missing values above it, the
    // two of them being the same figures told as a table and then as a plot,
    // ahead of the pages that go on to the patterns.

    image = '$tempDir/explore_missing_naniar_ggmissvar.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Comparison of Counts of Missing Values

        Generated using
        [naniar::gg_miss_var(ds)](https://www.rdocumentation.org/packages/naniar/topics/gg_miss_var).

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // PATTERN OF MISSING VALUES - TEXTUAL
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'md.pattern(tds');

    // Add a blank line between each sub-table.

    // lines = content.split('\n');

    // 20250203 gjw Remove this processing for now - it was not working for the
    // US Population dataset.
    //
    // for (int i = 0; i < lines.length; i++) {
    //   if (lines[i].startsWith(' ') && !RegExp(r'^\s+\d').hasMatch(lines[i])) {
    //     lines[i] = '\n${lines[i]}';
    //   }
    // }

    // content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Patterns of Missing Values - Textual

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/missing-values-in-rattle.html).

          Generated using
          [mice::md.pattern(ds)](https://www.rdocumentation.org/packages/mice/topics/md.pattern)

          Each **column** is a pattern of missing values across the different variabels.

          The **Count of Observations** is the number of observations having
          that particular pattern of missing values.

          The **Number Missing** is the number of variables with missing values
          in each pattern.

          For each **row** a **1** indicates present and **0** missing value.

          The **final column** is the number of missing values for that
          variable.

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // PATTERN OF MISSING VALUES - VISUAL
    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_missing_mice.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Patterns of Missing Values - Visual

        Generated using
        [mice::md.pattern(ds)](https://www.rdocumentation.org/packages/mice/topics/md.pattern)

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // Naniar gg miss var

    image = '$tempDir/explore_missing_naniar_ggmissupset.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Patterns of Missingness

        Generated using
        [naniar::gg_miss_upset(ds)](https://www.rdocumentation.org/packages/naniar/topics/gg_miss_upset).

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_missing_vim.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Aggregation of Missing Values - Visual

        Generated using
        [VIM::aggr(ds)](https://www.rdocumentation.org/packages/VIM/topics/aggr).

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

// 20260818 gjw Correlation of the missingness itself is the last of
    // the summaries, before the observation by observation picture.

    image = '$tempDir/explore_missing_correlation.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Correlation of Missing Values - Visual

        Generated using
        [stats::cor()](https://www.rdocumentation.org/packages/stats/topics/cor) and
        [corrplot::corrplot()](https://www.rdocumentation.org/packages/corrplot/topics/corrplot).

        Only the variables with missing values are considered here.

        Identify correlations between missingness of values across variables.

        ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////

    // 20260818 gjw This one goes last. It is a picture of every observation of
    // every variable, so it is the most detailed and the least summarised of
    // the missing value displays, and it reads better after the summaries than
    // in among them.

    image = '$tempDir/explore_missing_naniar_vismiss.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

        # Visualisation of Observations with Missing Values

        Generated using
        [naniar::vis_miss(ds)](https://www.rdocumentation.org/packages/naniar).

        ''',
          path: image,
        ),
      );
    }

    return PageViewer(pageController: pageController, pages: pages);
  }
}
