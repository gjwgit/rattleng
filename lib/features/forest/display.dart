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
import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/tree_algorithm.dart';
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
    int forestNo = ref.watch(treeNoForestProvider);
    AlgorithmType forestAlgorithm =
        ref.watch(algorithmForestProvider.notifier).state;

    List<Widget> pages = [showMarkdownFile(forestIntroFile, context)];

    String content = '';

    ////////////////////////////////////////////////////////////////////////

    if (forestAlgorithm == AlgorithmType.traditional) {
      content = rExtractForest(stdout, ref);

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

      content = rExtract(
        stdout,
        'printRandomForests(model_randomForest, ${forestNo})',
      );

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

      String oobRocImage = '$tempDir/model_random_forest_oob_roc_curve.svg';

      if (imageExists(oobRocImage)) {
        pages.add(
          ImagePage(
            title: 'OOB ROC Curve',
            path: oobRocImage,
          ),
        );
      }

      String riskImage = '$tempDir/model_rforest_risk.svg';

      if (imageExists(riskImage)) {
        pages.add(
          ImagePage(
            title: 'RISK CHART',
            path: riskImage,
          ),
        );
      }
    } else if (forestAlgorithm == AlgorithmType.conditional) {
      content = rExtractForest(stdout, ref);

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '# Random Forest Model\n\n'
                'Built using `cforest()`.\n\n',
            content: '\n$content',
          ),
        );
      }

      content = rExtract(
        stdout,
        'print(importance_df)',
      );

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '# Variable Importance\n\n'
                'Built using `verification::cforest()`.\n\n',
            content: '\n$content',
          ),
        );
      }

      String rulesContent = rExtract(
        stdout,
        'prettytree(model_conditionalForest@ensemble[[${forestNo}]], names(model_conditionalForest@data@get("input")))',
      );

      if (rulesContent.isNotEmpty) {
        pages.add(
          TextPage(
            title: '# Sample Rules\n\n'
                'Built using `party::prettytree()`.\n\n',
            content: '\n$rulesContent',
          ),
        );
      }

      String varImportanceImage = '$tempDir/model_conditional_forest.svg';

      if (imageExists(varImportanceImage)) {
        pages.add(
          ImagePage(
            title: 'VAR IMPORTANCE',
            path: varImportanceImage,
          ),
        );
      }

      String riskImage = '$tempDir/model_cforest_risk.svg';

      if (imageExists(riskImage)) {
        pages.add(
          ImagePage(
            title: 'RISK CHART',
            path: riskImage,
          ),
        );
      }
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
