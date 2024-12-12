/// Widget to display the Forest introduction and results.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-12-05 17:22:27 +1100 Graham Williams>
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
import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/single_image_page.dart';
import 'package:rattle/widgets/text_page.dart';

/// The Forest panel displays the instructions and then the model build output
/// and evaluations.

class ForestDisplay extends ConsumerStatefulWidget {
  const ForestDisplay({super.key});

  @override
  ConsumerState<ForestDisplay> createState() => _ForestDisplayState();
}

class _ForestDisplayState extends ConsumerState<ForestDisplay> {
  @override
  Widget build(BuildContext context) {
    // Get the PageController from Riverpod.

    final pageController = ref.watch(
      forestPageControllerProvider,
    );

    String stdout = ref.watch(stdoutProvider);
    int forestNo = ref.watch(treeNoForestProvider);
    AlgorithmType forestAlgorithm =
        ref.watch(algorithmForestProvider.notifier).state;

    List<Widget> pages = [showMarkdownFile(forestIntroFile, context)];

    String content = '';

    ////////////////////////////////////////////////////////////////////////

    // Default Forest text.

    forestAlgorithm == AlgorithmType.traditional
        ? content = rExtract(stdout, 'print(model_randomForest')
        : content = rExtract(stdout, 'print(model_cforest)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Random Forest Model

          Built using `randomForest()`.

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    if (forestAlgorithm == AlgorithmType.traditional) {
      // rExtractForest does not seem to work.

      // content = rExtractForest(stdout, ref);

      // if (content.isNotEmpty) {
      //   pages.add(
      //     TextPage(
      //       title: '# Random Forest Model\n\n'
      //           'Built using `randomForest()`.\n\n',
      //       content: '\n$content',
      //     ),
      //   );
      // }

      ////////////////////////////////////////////////////////////////////////

      content = rExtract(
        stdout,
        'printRandomForests(model_randomForest, ${forestNo})',
      );

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Sample Rules

            Built using `rattle::printRandomForest()`.

            ''',
            content: '\n$content',
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      content = rExtract(stdout, 'rn[order(rn[,3], decreasing=TRUE),]');

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Variable Importance &#8212; Numeric

            Built using `randomForest::importance()`

            ''',
            content: '\n$content',
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String image = '$tempDir/model_random_forest_varimp.svg';

      if (imageExists(image)) {
        pages.add(
          SingleImagePage(
            title: '''

            # Variable Importance &#8212; Plot

            ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String errorRatesImage = '$tempDir/model_random_forest_error_rate.svg';

      if (imageExists(errorRatesImage)) {
        pages.add(
          SingleImagePage(
            title: '''

            # Error Rate Plot

            ''',
            path: errorRatesImage,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String oobRocImage = '$tempDir/model_random_forest_oob_roc_curve.svg';

      if (imageExists(oobRocImage)) {
        pages.add(
          SingleImagePage(
            title: '''

            # Out of Bag ROC Curve

            ''',
            path: oobRocImage,
          ),
        );
      }
    } else if (forestAlgorithm == AlgorithmType.conditional) {
      ////////////////////////////////////////////////////////////////////////

      content = rExtractForest(stdout, ref);

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Random Forest Model

            Built using `cforest()`.

            ''',
            content: '\n$content',
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String rulesContent = rExtract(
        stdout,
        'prettytree(model_conditionalForest@ensemble[[${forestNo}]], names(model_conditionalForest@data@get("input")))',
      );

      if (rulesContent.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Sample Rules

            Built using `party::prettytree()`.

            ''',
            content: '\n$rulesContent',
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      content = rExtract(
        stdout,
        'print(importance_df)',
      );

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Variable Importance &#8212; Numeric

            Built using `verification::cforest()`.

            ''',
            content: '\n$content',
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String varImportanceImage = '$tempDir/model_conditional_forest.svg';

      if (imageExists(varImportanceImage)) {
        pages.add(
          SingleImagePage(
            title: '''

            # Variable Importance &#8212; Plot

            ''',
            path: varImportanceImage,
          ),
        );
      }
    }

    ////////////////////////////////////////////////////////////////////////

    String image = '';

    forestAlgorithm == AlgorithmType.traditional
        ? image = '$tempDir/model_randomForest_riskchart_training.svg'
        : image = '$tempDir/model_cforest_riskchart_training.svg';

    if (imageExists(image)) {
      pages.add(
        SingleImagePage(
          title: '''

          # Risk Chart &#8212; Optimistic Estimate of Performance

          Using the **training** dataset to evaluate the model performance.

          Visit [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).
            ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '';

    forestAlgorithm == AlgorithmType.traditional
        ? image = '$tempDir/model_randomForest_riskchart_tuning.svg'
        : image = '$tempDir/model_cforest_riskchart_tuning.svg';

    if (imageExists(image)) {
      pages.add(
        SingleImagePage(
          title: '''

          # Risk Chart &#8212; Unbiased Estimate of Performance

          Using the **tuning** dataset to evaluate the model performance.

          Visit [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).
            ''',
          path: image,
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
