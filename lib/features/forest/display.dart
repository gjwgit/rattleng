/// Widget to display the Forest introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-10-15 20:09:06 +1100 Graham Williams>
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
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

/// The FOREST panel displays the instructions and then the build output.

class ForestDisplay extends ConsumerStatefulWidget {
  const ForestDisplay({super.key});

  @override
  ConsumerState<ForestDisplay> createState() => _ForestDisplayState();
}

class _ForestDisplayState extends ConsumerState<ForestDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      forestPageControllerProvider,
    ); // Get the PageController from Riverpod
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(forestIntroFile, context)];

    String content = '';

    ////////////////////////////////////////////////////////////////////////

    content = rExtractForest(stdout);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Random Forest Model\n\n'
              'Built using `randomForest()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'rn[order(rn[,3], decreasing=TRUE),]');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Variable Importance\n\n'
              'Built using `randomForest::importance()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'printRandomForests(model_randomForest, 1)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Sample Rules\n\n'
              'Built using `rattle::printRandomForest()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    String image = '$tempDir/model_random_forest_varimp.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: 'VAR IMPORTANCE',
          path: image,
        ),
      );
    }

    String errorRatesImage = '$tempDir/model_random_forest_error_rate.svg';

    if (imageExists(errorRatesImage)) {
      pages.add(
        ImagePage(
          title: 'ERROR RATE',
          path: errorRatesImage,
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
