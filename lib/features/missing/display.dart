/// Widget to display the MISSING introduction and display output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-09-02 15:03:25 +1000 Graham Williams>
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
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
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
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(missingIntroFile, context)];

    String content = '';
    List<String> lines = [];

    ////////////////////////////////////////////////////////////////////////
    // TEXT PATTERN OF MISSING VALUES
    ////////////////////////////////////////////////////////////////////////

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

    pages.add(
      ImagePage(
        title: '''

        # Patterns of Missing Values - Visual

        Generated using
        [mice::md.pattern(ds)](https://www.rdocumentation.org/packages/mice/topics/md.pattern)

        ''',
        path: '$tempDir/explore_missing_mice.svg',
      ),
    );

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

    pages.add(
      ImagePage(
        title: '''

        # Aggregation of Missing Values - Visual

        Generated using
        [VIM::aggr(ds)](https://www.rdocumentation.org/packages/VIM/topics/aggr).

        ''',
        path: '$tempDir/explore_missing_vim.svg',
      ),
    );

    ////////////////////////////////////////////////////////////////////////

    pages.add(
      ImagePage(
        title: '''

        # Visualisation of Observations with Missing Values

        Generated using
        [naniar::vis_miss(ds)](https://www.rdocumentation.org/packages/naniar).

        ''',
        path: '$tempDir/explore_missing_naniar_vismiss.svg',
      ),
    );

    ////////////////////////////////////////////////////////////////////////
    // NANIAR GG MISS VAR
    ////////////////////////////////////////////////////////////////////////

    pages.add(
      ImagePage(
        title: '''

        # Comparison of Counts of Missing Values

        Generated using
        [naniar::gg_miss_var(ds)](https://www.rdocumentation.org/packages/naniar/topics/gg_miss_var).

        ''',
        path: '$tempDir/explore_missing_naniar_ggmissvar.svg',
      ),
    );

    ////////////////////////////////////////////////////////////////////////
    // NANIAR GG MISS VAR
    ////////////////////////////////////////////////////////////////////////

    pages.add(
      ImagePage(
        title: '''

        # Patterns of Missingness

        Generated using
        [naniar::gg_miss_upset(ds)](https://www.rdocumentation.org/packages/naniar/topics/gg_miss_upset).

        ''',
        path: '$tempDir/explore_missing_naniar_ggmissupset.svg',
      ),
    );

    return Pages(
      children: pages,
    );
  }
}
