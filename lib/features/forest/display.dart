/// Widget to display the Forest introduction and results.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Tuesday 2026-09-01 16:30:45 +1000 Graham Williams"
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
import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/tree.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/r/extract_formula.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
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

    final pageController = ref.watch(forestPageControllerProvider);

    String stdout = ref.watch(stdoutProvider);
    bool useValidation = ref.watch(useValidationSettingProvider);
    int forestNo = ref.watch(treeNoForestProvider);
    int forestMaxRules = ref.watch(maxRulesForestProvider);
    AlgorithmType forestAlgorithm =
        ref.watch(algorithmForestProvider.notifier).state;

    List<Widget> pages = [
      showMarkdownFile(context, forestIntroFile, 'assets/svg/forest.svg'),
    ];

    String content = '';

    ////////////////////////////////////////////////////////////////////////

    // Default Forest text.

    forestAlgorithm == AlgorithmType.traditional
        ? content = rExtract(stdout, 'print(model_randomForest')
            .replaceFirst(', ntree', ',\n              ntree')
            .replaceFirst(' import', '\n              import')
            .replaceFirst(', na.action =', ',\n              na.action =')
            .replaceFirst('               Type of', '\nType of')
            .replaceFirst(
              '                     Number of trees',
              '\nNumber of trees',
            )
            .replaceAll(' = ', '=')
            .replaceFirst('        OOB', 'OOB')
            .replaceFirst('of  error', 'of error')
            .replaceFirst('Confusion matrix:', '\nConfusion Matrix:\n')
        : content = rExtract(stdout, 'print(model_cforest)');

    content = content.replaceAll('Call:\n', '');

    if (forestAlgorithm == AlgorithmType.traditional) {
      const String scd = 'Summary of the Traditional Forest model.';

      final String fm = rExtractFormula(stdout);
      content = '$scd \n\nFormula: $fm\n$content';

      // Extract the list of tree sizes for the trees of the forest. From the
      // print command output we remove the first n space characters from each
      // line. The value of n is determined dynamically from the number of
      // spaces before the tree_number. (gjw 20250430)

      String sizes = rExtract(stdout, '> print(rf_tree_info)');
      RegExp regex = RegExp(r'^\s*');
      String matches = regex.stringMatch(sizes) ?? '';
      sizes = sizes
          .split('\n')
          .map(
            (line) => line.length >= matches.length
                ? line.substring(matches.length)
                : line,
          )
          .join('\n');

      // Keep just the first and last 20 lines if there are more the 40 lines.

      final maxLines = 10;
      List<String> lines = sizes.split('\n');
      int nlines = lines.length;
      List<String> keep = lines;
      if (nlines > maxLines * 3) {
        keep = ['See the CONSOLE for the full list.\n'] +
            lines.sublist(0, maxLines) +
            ['        ...        ...'] +
            lines.sublist(nlines - maxLines, nlines);
      }
      sizes = keep.join('\n');

      content = '$content\n\nTree Sizes:\n\n$sizes';
    }

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Random Forest Model

          Built using
          [randomForest::randomForest()](https://www.rdocumentation.org/packages/randomForest/topics/randomForest).

          ''',
          content: content,
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
      // SAMPLE RULES

      content = rExtract(
        stdout,
        'printRandomForest(model_randomForest, $forestNo, max.rules = $forestMaxRules)',
      );

      // Changing parameters makes Sample Rules disappear.
      // Keep the previous record.

      if (content.isEmpty) {
        content = rExtract(stdout, 'printRandomForest(model_randomForest');
      }

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Sample Rules

            Generated using
            [rattle::printRandomForests()](https://www.rdocumentation.org/packages/rattle/topics/printRandomForests).

            ''',
            content: content,
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

            Generated using
            [randomForest::importance()](https://www.rdocumentation.org/packages/randomForest/topics/importance).

            ''',
            content: content,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String image = '$tempDir/model_random_forest_varimp.svg';

      if (imageExists(image)) {
        pages.add(
          ImagePage(
            title: '''

            # Variable Importance &#8212; Plot

            Generated using
            [randomForest::importance()](https://www.rdocumentation.org/packages/randomForest/topics/importance).

            ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/model_random_forest_error_rate.svg';

      if (imageExists(image)) {
        pages.add(
          ImagePage(
            title: '''

            # Error Rate Plot

            ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/model_random_forest_oob_roc_curve.svg';

      if (imageExists(image)) {
        pages.add(
          ImagePage(
            title: '''

            # Out of Bag ROC Curve

            ''',
            path: image,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      image = '$tempDir/model_random_forest_leaf_node_distribution.svg';

      if (imageExists(image)) {
        pages.add(
          ImagePage(
            title: '''

            # Distribution of Tree Sizes

            ''',
            path: image,
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

            Built using `cforest()`. [party::cforest()](https://www.rdocumentation.org/packages/party/versions/1.1-0/topics/cforest)

            ''',
            content: content,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      content = rExtract(
        stdout,
        'prettytree(model_conditionalForest@ensemble[[$forestNo]]',
      );

      // Remove a continuation line.

      List<String> lines = content.split('\n');
      content = lines.where((line) => !line.startsWith('+')).join('\n');

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Sample Rules

            Built using
            [party::prettytree()](https://www.rdocumentation.org/packages/party/versions/1.1-0/topics/prettytree).

            ''',
            content: content,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      content = rExtract(stdout, 'print(importance_df)');

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Variable Importance &#8212; Numeric

            Built using `verification::cforest()`.

            ''',
            content: content,
          ),
        );
      }

      ////////////////////////////////////////////////////////////////////////

      String varImportanceImage = '$tempDir/model_conditional_forest.svg';

      if (imageExists(varImportanceImage)) {
        pages.add(
          ImagePage(
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
        ? image = '$tempDir/evaluate_randomForest_riskchart_training.svg'
        : image = '$tempDir/evaluate_cforest_riskchart_training.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
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
        ? image = '$tempDir/evaluate_randomForest_riskchart_tuning.svg'
        : image = '$tempDir/evaluate_cforest_riskchart_tuning.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Risk Chart &#8212; Unbiased Estimate of Performance

          Using the **${useValidation ? 'validation' : 'tuning'}** dataset to
          evaluate the model performance.

          Visit [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).
            ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(pageController: pageController, pages: pages);
  }
}
