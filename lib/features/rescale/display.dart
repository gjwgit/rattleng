/// Widget to display the RESHAPE introduction and output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-12-19 11:22:39 +1100 Graham Williams>
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
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_summary.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class RescaleDisplay extends ConsumerStatefulWidget {
  const RescaleDisplay({super.key});

  @override
  ConsumerState<RescaleDisplay> createState() => _RescaleDisplayState();
}

class _RescaleDisplayState extends ConsumerState<RescaleDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      rescalePageControllerProvider,
    ); // Get the PageController from Riverpod

    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [
      showMarkdownFile(
        context,
        rescaleIntroFile,
        'assets/svg/rescale.svg',
      ),
    ];

    // Second page is the data summary. Be sure to include the IGNOREd variables
    // since we may transform it multiple times.

    String content = rExtractSummary(stdout);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Dataset Summary

          Generated using
          [base::summary(ds)](https://www.rdocumentation.org/packages/base/topics/summary).

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
