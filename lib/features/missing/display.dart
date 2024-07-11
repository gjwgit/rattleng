/// Widget to display the MISSING introduction and display output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-07-12 09:47:32 +1000 Graham Williams>
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

    content = rExtract(stdout, 'md.pattern(ds)');

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
          title: '# Patterns of Missing Data - Textual\n\n'
              'Generated using `mice::md.pattern(ds)`',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////
    // USING VIM
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'aggr(ds');

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
          title: '# Variables with Missing Data - Sorted\n\n'
              'Generated using `VIM::aggr(ds)`',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    pages.add(
      const ImagePage(
        title: 'Missing Value Visualisation\n\n'
            'Generated using `mice::md(ds)`',
        path: '/tmp/explore_missing_mice.svg',
      ),
    );

    pages.add(
      const ImagePage(
        title: 'Missing Value Visualisation\n\n'
            'Generated using `VIM::aggr(ds)`',
        path: '/tmp/explore_missing_vim.svg',
      ),
    );

    return Pages(
      children: pages,
    );
  }
}
