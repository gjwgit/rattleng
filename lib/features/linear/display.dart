/// Widget to display the LINEAR introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-09-26 08:27:52 +1000 Graham Williams>
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
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class LinearDisplay extends ConsumerStatefulWidget {
  const LinearDisplay({super.key});

  @override
  ConsumerState<LinearDisplay> createState() => _LinearDisplayState();
}

class _LinearDisplayState extends ConsumerState<LinearDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      linearPageControllerProvider,
    );
    String stdout = ref.watch(stdoutProvider);
    String content = '';

    List<Widget> pages = [
      showMarkdownFile(linearIntroFile, context),
    ];

    content = rExtract(stdout, 'print(summary(model_glm))');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Linear Model\n\n'
              'Built using `glm()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
