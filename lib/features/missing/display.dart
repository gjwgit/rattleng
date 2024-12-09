/// Widget to display the MISSING introduction and display output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-10-05 15:43:30 +1000 Graham Williams>
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
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/utils/show_markdown_file.dart';
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

    List<Widget> pages = [showMarkdownFile(missingIntroFile, context)];

    String content = '';
    String image = '';
    List<String> lines = [];

    ////////////////////////////////////////////////////////////////////////

    // Text pattern of missing values.

    content = rExtract(stdout, 'md.pattern(');

    // Add a blank line between each sub-table.

    lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith(' ') && !RegExp(r'^\s+\d').hasMatch(lines[i])) {
        lines[i] = '\n${lines[i]}';
      }
    }

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Patterns of Missing Data - Textual

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/missing-values-in-rattle.html)
          and
          [mice::md.pattern(ds)](https://www.rdocumentation.org/packages/mice/topics/md.pattern)

          ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_missing_mice.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          titles: [
            '''

        # Patterns of Missing Values - Visual

        Generated using
        [mice::md.pattern(ds)](https://www.rdocumentation.org/packages/mice/topics/md.pattern)

        '''
          ],
          paths: [image],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'aggr(');

    // Remove the line beginning with + (a continuation)

    lines = content.split('\n');

    lines = lines.where((line) => !line.startsWith('+')).toList();

    // Rejoin the lines.

    content = lines.join('\n');

    // Rename Count to Proportion!

    content = content.replaceAll('     Count', 'Proportion');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Aggregation of Missing Values - Textual

          Generated using
          [VIM::aggr(ds)](https://www.rdocumentation.org/packages/VIM/topics/aggr).

          ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_missing_vim.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          titles: [
            '''
          
        # Aggregation of Missing Values - Visual
          
        Generated using
        [VIM::aggr(ds)](https://www.rdocumentation.org/packages/VIM/topics/aggr).
        
        '''
          ],
          paths: [image],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/explore_missing_naniar_vismiss.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          titles: [
            '''

        # Visualisation of Observations with Missing Values

        Generated using
        [naniar::vis_miss(ds)](https://www.rdocumentation.org/packages/naniar).

        '''
          ],
          paths: [image],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // Naniar gg miss var

    image = '$tempDir/explore_missing_naniar_ggmissvar.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          titles: [
            '''

        # Comparison of Counts of Missing Values

        Generated using
        [naniar::gg_miss_var(ds)](https://www.rdocumentation.org/packages/naniar/topics/gg_miss_var).

        '''
          ],
          paths: [image],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // Naniar gg miss var

    image = '$tempDir/explore_missing_naniar_ggmissupset.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          titles: [
            '''

        # Patterns of Missingness

        Generated using
        [naniar::gg_miss_upset(ds)](https://www.rdocumentation.org/packages/naniar/topics/gg_miss_upset).

        '''
          ],
          paths: [image],
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
