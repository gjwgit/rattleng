/// Widget to display the BOOST introduction and outputs.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-10-09 09:31:18 +1100 Graham Williams>
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
//
// Note: The "Dataset" button is not present in this file. It might be located
// in another file responsible for the app's navigation or main layout.
///
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/boost.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions and a navigator to the outputs.

class BoostDisplay extends ConsumerStatefulWidget {
  const BoostDisplay({super.key});

  @override
  ConsumerState<BoostDisplay> createState() => _BoostDisplayState();
}

class _BoostDisplayState extends ConsumerState<BoostDisplay> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);
    String algorithm = ref.read(algorithmBoostProvider.notifier).state;

    // Populate the initial overview

    List<Widget> pages = [showMarkdownFile(boostIntroFile, context)];

    final pageController = ref.watch(boostPageControllerProvider);

    if (algorithm == 'Extreme') {
      String content =
          rExtract(stdout, 'print(importance_dt, row.names = FALSE)');

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

          # XGBoost - Summary

          Visit the 
          [Guide](https://xgboost.readthedocs.io/en/stable/R-package/xgboostPresentation.html). Built
          using
          [xgb::xgboost()](https://www.rdocumentation.org/packages/xgboost/topics/xgb.train).

            ''',
            content: '\n$content',
          ),
        );
      }

      String image = '$tempDir/model_xgb_importance.svg';

      if (imageExists(image)) {
        pages.add(
          ImagePage(
            title: '''

          # Variable Importance

          Generated using
          [xgb::xgb.importance()](https://www.rdocumentation.org/packages/xgboost/topics/xgb.importance).
          
          ''',
            path: image,
          ),
        );
      }
    } else if (algorithm == 'Adaptive') {
      String content = rExtract(stdout, 'print(model_ada)');

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

          # AdaBoost - Summary

          Visit the 
          [Guide](https://www.rdocumentation.org/packages/JOUSBoost/topics/adaboost). Built
          using
          [ada::ada()](https://www.rdocumentation.org/packages/ada/topics/ada).

            ''',
            content: '\n$content',
          ),
        );
      }

      String image = '$tempDir/model_ada_boost.svg';

      if (imageExists(image)) {
        pages.add(
          ImagePage(
            title: '''

          # Variable Importance

          Generated using
          [ada::varplot()](https://www.rdocumentation.org/packages/ada/topics/pairs.ada).

          ''',
            path: image,
          ),
        );
      }
    }

    ////////////////////////////////////////////////////////////////////////

    String riskImage = '';

    algorithm == 'Extreme'
        ? riskImage = '$tempDir/model_xgboost_riskchart_training.svg'
        : riskImage = '$tempDir/model_adaboost_riskchart_training.svg';

    if (imageExists(riskImage)) {
      pages.add(
        ImagePage(
          title: '''

          # Risk Chart &#8212; Unbiased Estimate of Performance

          Using the **training** dataset to evaluate the model performance.

          Visit [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).
            ''',
          path: riskImage,
        ),
      );
    }

    algorithm == 'Extreme'
        ? riskImage = '$tempDir/model_xgboost_riskchart_tuning.svg'
        : riskImage = '$tempDir/model_adaboost_riskchart_tuning.svg';

    if (imageExists(riskImage)) {
      pages.add(
        ImagePage(
          title: '''

          # Risk Chart &#8212; Unbiased Estimate of Performance

          Using the **tuning** dataset to evaluate the model performance.

          Visit [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).
            ''',
          path: riskImage,
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
