/// Widget to display the SUMMARY introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-06-13 10:06:28 +1000 Graham Williams>
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

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/colors.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/markdown_file.dart';

/// The panel displays the instructions or the output.

class SummaryPanel extends ConsumerStatefulWidget {
  const SummaryPanel({super.key});

  @override
  ConsumerState<SummaryPanel> createState() => _SummaryPanelState();
}

class _SummaryPanelState extends ConsumerState<SummaryPanel> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    String contents = rExtract(stdout, 'contents(ds)');
    // contents = rMarkdownContents(contents);

    return contents == ''
        ? Expanded(
            child: Center(
              child: sunkenMarkdownFileBuilder(summaryIntroFile),
            ),
          )
        : Expanded(
            child: Container(
              decoration: sunkenBoxDecoration,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MarkdownBody(data: '**Summary of the Dataset**'),
                    SelectableText(
                      contents,
                      style: monoTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
