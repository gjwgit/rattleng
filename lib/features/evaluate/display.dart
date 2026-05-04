/// Widget to display the Evaluate introduction and evaluations.
///
/// Copyright (C) 2024-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Tuesday 2025-08-05 14:00:01 +1000 Graham Williams"
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/tree.dart';
import 'package:rattle/r/extract_evaluate.dart';
import 'package:rattle/utils/get_risk.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/is_numeric_target.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/multi_image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/text_page.dart';

/// A panel to display an overview for the evaluate tab and then pages to
/// present an evaluation (the error matrix and a set of charts) for any built
/// model.

class EvaluateDisplay extends ConsumerStatefulWidget {
  const EvaluateDisplay({super.key});

  @override
  ConsumerState<EvaluateDisplay> createState() => _EvaluateDisplayState();
}

class _EvaluateDisplayState extends ConsumerState<EvaluateDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(evaluatePageControllerProvider);

    // Set up the first page to contain the appropriate overview/introduction to
    // the evaluate function (gjw 20250309).

    List<Widget> pages = [showMarkdownFile(context, evaluateIntroFile)];

    // From the R output in stdout we will extract the error matrix that is
    // clearly marked in the R output with the evaluation dataset type (Tuning
    // or Testing, etc.). We also need to account for the user chosen
    // nomenclature of Tuning/Validation (gjw 20250309).

    final stdout = ref.watch(stdoutProvider);
    String datasetType = ref.watch(datasetTypeProvider);
    bool useValidation = ref.watch(useValidationSettingProvider);
    if (datasetType == 'Tuning' && useValidation) datasetType = 'Validation';

    final dtype = datasetType.toLowerCase();
    bool numericTarget = isNumericTarget(ref);

    if (numericTarget) {
      // ── Regression display path ─────────────────────────────────────────
      // Show a text page with the regression summary (RMSE / MAE / R²)
      // extracted from stdout, then scatter and residual plot image pages.

      final regContent = rExtractRegressionEvaluate(stdout, datasetType, ref);
      if (regContent.trim().isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Regression Performance Metrics

            RMSE, MAE, and R² computed over the **$datasetType** dataset.

            ''',
            content: '\n$regContent',
          ),
        );
      }

      // Model display names shared with the classification path.
      final modelDisplayNames = {
        'rpart': 'RPART',
        'ctree': 'CTREE',
        'randomForest': 'RANDOM FOREST',
        'cforest': 'CONDITIONAL FOREST',
        'xgboost': 'XGBoost',
        'svm': 'SVM',
        'linear': 'LINEAR',
        'nnet': 'NNET',
        'neuralnet': 'NEURALNET',
      };

      final evaluateProviders = {
        'rpart': ref.watch(treeEvaluateProvider),
        'ctree': ref.watch(treeEvaluateProvider),
        'linear': ref.watch(linearEvaluateProvider),
        'nnet': ref.watch(neuralEvaluateProvider),
        'neuralnet': ref.watch(neuralEvaluateProvider),
        'svm': ref.watch(svmEvaluateProvider),
        'cforest': ref.watch(forestEvaluateProvider),
        'randomForest': ref.watch(forestEvaluateProvider),
        'xgboost': ref.watch(boostEvaluateProvider),
      };

      for (var plotType in ['scatter', 'residuals']) {
        List<String> images = [];
        List<String> titles = [];
        for (var model in modelDisplayNames.keys) {
          bool isTicked = evaluateProviders[model] ?? false;
          String imagePath =
              '$tempDir/evaluate_${model}_regression_${plotType}_$dtype.svg';
          if (isTicked && imageExists(imagePath)) {
            images.add(imagePath);
            titles.add(modelDisplayNames[model]!);
          }
        }
        if (images.isNotEmpty) {
          String pageTitle = plotType == 'scatter'
              ? 'Actual vs Predicted'
              : 'Residuals vs Fitted';
          pages.add(
            MultiImagePage(
              titles: titles,
              paths: images,
              pageTitle: pageTitle,
              pageDoc: null,
            ),
          );
        }
      }
    } else {
      // ── Classification display path ─────────────────────────────────────────

      // Get the risk variable setting to conditionally display charts.

      String datasetRisk = getRisk(ref);

      final content = rExtractEvaluate(stdout, datasetType, ref);

      // Process the content to ensure that we have the expected output to display
      // in Rattle and if so, add a new page to display the Error Matrix we have
      // just extracted (gjw 20250309).

      if (content.trim().split('\n').length > 1) {
        pages.add(
          TextPage(
            title: '''

          # Error Matrix

          Built using
          [errorMatrix::errorMatrix](https://www.rdocumentation.org/packages/rattle/topics/errorMatrix)

          ''',
            content: '\n$content',
          ),
        );
      }

      // We need to identify the model specific SVG files for each of the
      // evaluation types that we support in Rattle. All files follow a very
      // distinct naming scheme and we need to coordinate the names we use here
      // with those in `assets/r/evaluate_model_*.R` (20250312 gjw).

      final evaluationTypes = [
        'roc',
        'riskchart',
        // 'hand', The hmeasure package was removed from CRAN 20250802.
        'rocr',
      ];

      final modelDisplayNames = {
        'rpart': 'RPART',
        'ctree': 'CTREE',
        'randomForest': 'RANDOM FOREST',
        'cforest': 'CONDITIONAL FOREST',
        'xgboost': 'XGBoost',
        'adaboost': 'AdaBoost',
        'svm': 'SVM',
        'linear': 'LINEAR',
        'nnet': 'NNET',
        'neuralnet': 'NEURALNET',
      };

      final evaluateProviders = {
        'adaboost': ref.watch(boostEvaluateProvider),
        'rpart': ref.watch(treeEvaluateProvider),
        'ctree': ref.watch(treeEvaluateProvider),
        'linear': ref.watch(linearEvaluateProvider),
        'nnet': ref.watch(neuralEvaluateProvider),
        'neuralnet': ref.watch(neuralEvaluateProvider),
        'svm': ref.watch(svmEvaluateProvider),
        'cforest': ref.watch(forestEvaluateProvider),
        'randomForest': ref.watch(forestEvaluateProvider),
        'xgboost': ref.watch(boostEvaluateProvider),
      };

      final evalTypePageDetails = {
        'roc': {
          'title': 'Receiver-Operating Characteristic (ROC) '
              'and Area Under the Curve (AUC)',
          'documentation': 'Reference [ROC](https://developers.google.com/'
              'machine-learning/crash-course/classification/roc-and-auc).',
        },
        'riskchart': {'title': 'Risk Chart', 'documentation': null},
        // 20250805 gjw The hmeasure package was removed from 20250802.
        //
        // 'hand': {
        //   'title': 'H-Measure &#8212; Coherent Alternative to AUC',
        //   'documentation': 'Built using [hmeasure::HMeasure](https://'
        //       'www.rdocumentation.org/packages/hmeasure).',
        // },
        //
        'rocr': {
          'title': 'Combined Metrics: Cost, Lift, Sensitivity, and Precision',
          'documentation':
              'Combines Cost Curve, Lift, Sensitivity, and Precision metrics into a single visualization.',
        },
      };

      // For each of the evaluation types we now iterate over the expected image
      // files and for those that exist and the user interface has that model type
      // ticked, we add the image file for display (gjw 20250309).

      for (var evalType in evaluationTypes) {
        // Conditionally skip risk chart if datasetRisk is NULL or empty.

        if (evalType == 'riskchart' &&
            (datasetRisk == 'NULL' || datasetRisk.isEmpty)) {
          continue;
        }

        String prefix = 'evaluate';

        List<String> images = [];
        List<String> titles = [];

        for (var model in modelDisplayNames.keys) {
          bool isTicked = evaluateProviders[model] ?? false;

          String imagePath =
              '$tempDir/${prefix}_${model}_${evalType}_$dtype.svg';

          if (isTicked && imageExists(imagePath)) {
            images.add(imagePath);
            titles.add(modelDisplayNames[model]!);
          }
        }

        if (images.isNotEmpty) {
          pages.add(
            MultiImagePage(
              titles: titles,
              paths: images,
              pageTitle: evalTypePageDetails[evalType]!['title']!,
              pageDoc: evalTypePageDetails[evalType]!['documentation'],
            ),
          );
        }
      }
    } // end classification else block

    return PageViewer(pageController: pageController, pages: pages);
  }
}
