/// Widget to display the Evaluate introduction and evaluations.
///
/// Copyright (C) 2024-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2025-03-12 08:30:19 +1100 Graham Williams>
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
import 'package:rattle/r/extract_evaluate.dart';
import 'package:rattle/utils/image_exists.dart';
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

    final content = rExtractEvaluate(stdout, datasetType, ref);
    final dtype = datasetType.toLowerCase();

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

    final models = [
      'adaboost',
      'rpart',
      'ctree',
      'linear',
      'nnet',
      'neuralnet',
      'svm',
      'cforest',
      'randomForest',
      'xgboost',
    ];

    final evaluationTypes = [
      'roc',
      'riskchart',
      'hand',
      'cost_curve',
      'lift',
      'sensitivity',
      'precision',
    ];

    final modelDisplayNames = {
      'adaboost': 'AdaBoost',
      'rpart': 'RPART',
      'ctree': 'CTREE',
      'linear': 'LINEAR',
      'nnet': 'NNET',
      'neuralnet': 'NEURALNET',
      'svm': 'SVM',
      'cforest': 'CONDITIONAL FOREST',
      'randomForest': 'RANDOM FOREST',
      'xgboost': 'XGBoost',
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
      'riskchart': {
        'title': 'Risk Chart',
        'documentation': null,
      },
      'hand': {
        'title': 'H-Measure &#8212; Coherent Alternative to AUC',
        'documentation': 'Built using [hmeasure::HMeasure](https://'
            'www.rdocumentation.org/packages/hmeasure).',
      },
      'cost_curve': {
        'title': 'Cost Curve &#8212; Expected Misclassification Cost',
        'documentation':
            'Built using [ROCR::performance](https://www.rdocumentation.org/'
                'packages/ROCR/topics/performance) with measure=ecost.',
      },
      'lift': {
        'title': 'Lift &#8212; Model Improvement over Random',
        'documentation':
            'Built using [ROCR::performance](https://www.rdocumentation.org/'
                'packages/ROCR/topics/performance) with measure=lift.',
      },
      'sensitivity': {
        'title': 'Sensitivity &#8212; Measures Positive Detection',
        'documentation':
            'Built using [ROCR::performance](https://www.rdocumentation.org/'
                'packages/ROCR/topics/performance) with measure=sens.',
      },
      'precision': {
        'title': 'Precision &#8212; Measures Correct Positive Predictions',
        'documentation':
            'Built using [ROCR::performance](https://www.rdocumentation.org/'
                'packages/ROCR/topics/performance) with measure=prec.',
      },
    };

    // For each of the evaluation types we now iterate over the expected image
    // files and for those that exist and the user interface has that model type
    // ticked, we add the image file for display (gjw 20250309).

    for (var evalType in evaluationTypes) {
      List<String> images = [];
      List<String> titles = [];

      for (var model in models) {
        bool isTicked = evaluateProviders[model] ?? false;
        String prefix = 'evaluate';
        String imagePath = '$tempDir/${prefix}_${model}_${evalType}_$dtype.svg';

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

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
