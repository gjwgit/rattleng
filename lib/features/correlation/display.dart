/// Widget to display the CORRELATION introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-07-14 20:26:02 +1000 Graham Williams>
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
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
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
    String stdout = ref.watch(stdoutProvider);
    List<Widget> pages = [showMarkdownFile(correlationIntroFile, context)];

    String content = '';
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
          title: '# Correlation - Numeric Data\n\n'
              'Generated using `stats::cor()`',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    pages.add(
      ImagePage(
        title: 'Variable Correlation Plot\n\n'
            'Generated using `corrplot::corrplot(ds)`',
        path: '$tempDir/explore_correlation.svg',
      ),
    );

    return Pages(
      children: pages,
    );
  }
}
