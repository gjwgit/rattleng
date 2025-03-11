/// Widget to display the Evaluate introduction.
///
/// Copyright (C) 2024-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2025-03-09 09:01:45 +1100 Graham Williams>
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
/// present an evluation (the error matrix or else the set of charts) of any
/// built model.

class EvaluateDisplay extends ConsumerStatefulWidget {
  const EvaluateDisplay({super.key});

  @override
  ConsumerState<EvaluateDisplay> createState() => _EvaluateDisplayState();
}

class _EvaluateDisplayState extends ConsumerState<EvaluateDisplay> {
  @override
  Widget build(BuildContext context) {
    // We use a PageController from Riverpod so that XXXX.

    final pageController = ref.watch(
      evaluatePageControllerProvider,
    );

    // 20250309 gjw Set up the first page to contain the appropriate
    // overview/introduction to the evaluate function.

    List<Widget> pages = [showMarkdownFile(context, evaluateIntroFile)];

    // 20250309 gjw We will populate the text content with output from the R
    // console.

    String content = '';

    // 20250309 gjw From the R output, kept in the Riverpod stdout, we will
    // extract the error matrix output that is clearly marked in the R output
    // with the evaluation dataset type (Tuning or Testing, etc.). We also need
    // to account for the user chosen nomenclature of Tuning/Validation.

    String stdout = ref.watch(stdoutProvider);

    String datasetType = ref.watch(datasetTypeProvider);
    bool useValidation = ref.watch(useValidationSettingProvider);
    if (datasetType == 'Tuning' && useValidation) datasetType = 'Validation';

    content = rExtractEvaluate(stdout, datasetType, ref);

    // Dataset type in file name is all lowercase.

    String dtype = datasetType.toLowerCase();

    // 20250309 gjw Process the content to ensure that we have the expected
    // output to display in Rattle and if so, add a new page to display the
    // Error Matrix, if any, we have just extracted.

    bool contentFound = content.trim().split('\n').length > 1;

    if (contentFound) {
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

    // 20250309 gjw We need to identify the model specific SVG files for each of
    // the evaluation types that we support in Rattle. All files follw a very
    // distinct naming scheme and we need to coordinate the names we use here
    // with those in `assets/r/evaluate_model_*.R`.

    // 20250309 gjw Zheyaun, this surely looks like an opportunity for a
    // labelled array rather then all of the replicated work? Create a variable
    // to list the model types (rpart, adaboost, ctree, linear, nnet, neuralnet,
    // svm, ...) and another for the evaluation types (roc, costcurve,
    // riskchart, ...). Then iterate over them to decide what to display. Should
    // be able to reduce the number of lines of code and it will be a lot easier
    // to understand and to maintain.

    // 20250309 gjw Zheyuan, we seem to have changed the file naming scheme. It
    // should be `evaluate_rpart_roc_tuning.svg`, etc. and
    // `evaluate_rpart_riskchart_testing.svg` and so on. Then most of the
    // following code can be replaced by a simpler loop over the model and
    // measure.

    String rocAdaBoostImage = '$tempDir/model_evaluate_roc_adaboost_$dtype.svg';
    String rocCtreeImage = '$tempDir/model_evaluate_roc_ctree_$dtype.svg';
    String rocLinearImage = '$tempDir/model_evaluate_roc_linear_$dtype.svg';
    String rocNNETImage = '$tempDir/model_evaluate_roc_nnet_$dtype.svg';
    String rocNeuralNetImage =
        '$tempDir/model_evaluate_roc_neuralnet_$dtype.svg';
    String rocRpartImage = '$tempDir/model_evaluate_roc_rpart_$dtype.svg';
    String rocSVMImage = '$tempDir/model_evaluate_roc_svm_$dtype.svg';
    String rocCforestImage = '$tempDir/model_evaluate_roc_cforest_$dtype.svg';
    String rocRforestImage =
        '$tempDir/model_evaluate_roc_randomForest_$dtype.svg';
    String rocXGBoostImage = '$tempDir/model_evaluate_roc_xgboost_$dtype.svg';

    String riskChartRpartImage = '$tempDir/model_rpart_riskchart_$dtype.svg';
    String riskChartLinearImage = '$tempDir/model_linear_riskchart_$dtype.svg';
    String riskChartCtreeImage = '$tempDir/model_ctree_riskchart_$dtype.svg';
    String riskChartAdaBoostImage =
        '$tempDir/model_adaboost_riskchart_$dtype.svg';
    String riskChartNNETImage = '$tempDir/model_nnet_riskchart_$dtype.svg';
    String riskChartNeuralNetImage =
        '$tempDir/model_neuralnet_riskchart_$dtype.svg';
    String riskChartSVMImage = '$tempDir/model_svm_riskchart_$dtype.svg';
    String riskChartCforestImage =
        '$tempDir/model_cforest_riskchart_$dtype.svg';
    String riskChartRforestImage =
        '$tempDir/model_randomForest_riskchart_$dtype.svg';
    String riskChartXGBoostImage =
        '$tempDir/model_xgboost_riskchart_$dtype.svg';

    String handRpartImage = '$tempDir/model_evaluate_hand_rpart_$dtype.svg';
    String handCtreeImage = '$tempDir/model_evaluate_hand_ctree_$dtype.svg';
    String handRForestImage =
        '$tempDir/model_evaluate_hand_randomForest_$dtype.svg';
    String handCForestImage = '$tempDir/model_evaluate_hand_cforest_$dtype.svg';
    String handXGBoostImage = '$tempDir/model_evaluate_hand_xgboost_$dtype.svg';
    String handAdaBoostImage =
        '$tempDir/model_evaluate_hand_adaboost_$dtype.svg';
    String handSVMImage = '$tempDir/model_evaluate_hand_svm_$dtype.svg';
    String handLinearImage = '$tempDir/model_evaluate_hand_linear_$dtype.svg';
    String handNNETImage = '$tempDir/model_evaluate_hand_nnet_$dtype.svg';
    String handNeuralNetImage =
        '$tempDir/model_evaluate_hand_neuralnet_$dtype.svg';

    String costCurveRpartImage =
        '$tempDir/model_evaluate_cost_curve_rpart_$dtype.svg';

    bool treeBoxTicked = ref.watch(treeEvaluateProvider);
    bool forestBoxTicked = ref.watch(forestEvaluateProvider);
    bool boostBoxTicked = ref.watch(boostEvaluateProvider);
    bool svmBoxTicked = ref.watch(svmEvaluateProvider);
    bool neuralBoxTicked = ref.watch(neuralEvaluateProvider);
    bool linearBoxTicked = ref.watch(linearEvaluateProvider);

    List<String> rocImages = [];
    List<String> rocImagesTitles = [];

    List<String> handImages = [];
    List<String> handImagesTitles = [];

    List<String> riskChartImages = [];
    List<String> riskChartImagesTitles = [];

    List<String> costCurveImages = [];
    List<String> costCurveImagesTitles = [];

    // List of image-title pairs for ROC data.

    final rocImageData = [
      {
        'image': rocAdaBoostImage,
        'title': 'AdaBoost',
        'ticked': boostBoxTicked,
      },
      {'image': rocRpartImage, 'title': 'RPART', 'ticked': treeBoxTicked},
      {'image': rocCtreeImage, 'title': 'CTREE', 'ticked': treeBoxTicked},
      {'image': rocNNETImage, 'title': 'NNET', 'ticked': neuralBoxTicked},
      {
        'image': rocNeuralNetImage,
        'title': 'NEURALNET',
        'ticked': neuralBoxTicked,
      },
      {
        'image': rocLinearImage,
        'title': 'LINEAR',
        'ticked': linearBoxTicked,
      },
      {
        'image': rocRforestImage,
        'title': 'RANDOM FOREST',
        'ticked': forestBoxTicked,
      },
      {'image': rocSVMImage, 'title': 'SVM', 'ticked': svmBoxTicked},
      {
        'image': rocCforestImage,
        'title': 'CONDITIONAL FOREST',
        'ticked': forestBoxTicked,
      },
      {'image': rocXGBoostImage, 'title': 'XGBoost', 'ticked': boostBoxTicked},
    ];

    // List of image-title pairs for ROC data.

    final riskChartImageData = [
      {'image': riskChartRpartImage, 'title': 'RPART'},
      {'image': riskChartCtreeImage, 'title': 'CTREE'},
      {'image': riskChartAdaBoostImage, 'title': 'AdaBoost'},
      {'image': riskChartNNETImage, 'title': 'NNET'},
      {'image': riskChartNeuralNetImage, 'title': 'NEURALNET'},
      {'image': riskChartRforestImage, 'title': 'RANDOM FOREST'},
      {'image': riskChartSVMImage, 'title': 'SVM'},
      {'image': riskChartCforestImage, 'title': 'CONDITIONAL FOREST'},
      {'image': riskChartXGBoostImage, 'title': 'XGBoost'},
      {'image': riskChartLinearImage, 'title': 'LINEAR'},
    ];
    // List of image-title pairs for Hand plot.

    final handImageData = [
      {'image': handRpartImage, 'title': 'RPART', 'ticked': treeBoxTicked},
      {'image': handCtreeImage, 'title': 'CTREE', 'ticked': treeBoxTicked},
      {
        'image': handRForestImage,
        'title': 'RANDOM FOREST',
        'ticked': forestBoxTicked,
      },
      {
        'image': handCForestImage,
        'title': 'CONDITIONAL FOREST',
        'ticked': forestBoxTicked,
      },
      {
        'image': handAdaBoostImage,
        'title': 'AdaBoost',
        'ticked': boostBoxTicked,
      },
      {'image': handXGBoostImage, 'title': 'XGBoost', 'ticked': boostBoxTicked},
      {'image': handSVMImage, 'title': 'SVM', 'ticked': svmBoxTicked},
      {'image': handLinearImage, 'title': 'LINEAR', 'ticked': linearBoxTicked},
      {'image': handNNETImage, 'title': 'NNET', 'ticked': neuralBoxTicked},
      {
        'image': handNeuralNetImage,
        'title': 'NEURALNET',
        'ticked': neuralBoxTicked,
      },
    ];

    // List of image-title pairs for Hand plot.

    final costCurveImageData = [
      {'image': costCurveRpartImage, 'title': 'RPART', 'ticked': treeBoxTicked},
    ];

    // 20250309 gjw For each of the evaluation types we now iterate over the
    // expected image files and for those that exist and the user interface has
    // that model type ticked, we add the image file for display.

    // 20250309 gjw Zheyuan Do you need `== true` here because data['ticked']
    // will either be true or false anyhow?

    for (var data in rocImageData) {
      if (imageExists(data['image']!.toString()) && data['ticked'] == true) {
        rocImages.add(data['image']!.toString());
        rocImagesTitles.add(data['title']!.toString());
      }
    }

    for (var data in riskChartImageData) {
      if (imageExists(data['image']!)) {
        riskChartImages.add(data['image']!);
        riskChartImagesTitles.add(data['title']!);
      }
    }

    for (var data in handImageData) {
      if (imageExists(data['image']!.toString()) && data['ticked'] == true) {
        handImages.add(data['image']!.toString());
        handImagesTitles.add(data['title']!.toString());
      }
    }

    for (var data in costCurveImageData) {
      if (imageExists(data['image']!.toString()) && data['ticked'] == true) {
        costCurveImages.add(data['image']!.toString());
        costCurveImagesTitles.add(data['title']!.toString());
      }
    }

    // 20250309 gjw For each of the evaluation types if we have images to
    // display then we add a new page to display the charts. Note that for a
    // single evalautin we place all charts across multiple models on a single
    // page.

    if (rocImages.isNotEmpty) {
      pages.add(
        MultiImagePage(
          titles: rocImagesTitles,
          paths: rocImages,
          // 20250309 gjw Zheyuan Isn't this the tite for the page? Call it pageTitle.
          appBarImage:
              'Receiver-Operating Characteristic (ROC) and Area Under the Curve (AUC)',
          // 20250309 gjw Zheyuan Isn't this the documentation for the page?
          // Call it pageDoc and allow it to be multiple lines in a triple
          // quoted string.
          buildHyperLink:
              'Reference [ROC](https://developers.google.com/machine-learning/crash-course/classification/roc-and-auc).',
        ),
      );
    }

    if (handImages.isNotEmpty) {
      pages.add(
        MultiImagePage(
          titles: handImagesTitles,
          paths: handImages,
          appBarImage: 'H-Measure &#8212; Coherent Alternative to AUC',
          buildHyperLink:
              'Built using [hmeasure::HMeasure](https://www.rdocumentation.org/packages/hmeasure).',
        ),
      );
    }

    if (riskChartImages.isNotEmpty) {
      pages.add(
        MultiImagePage(
          titles: riskChartImagesTitles,
          paths: riskChartImages,
          appBarImage: 'Risk Chart',
        ),
      );
    }

    if (costCurveImages.isNotEmpty) {
      debugPrint('costCurveImages: $costCurveImages');
      pages.add(
        MultiImagePage(
          titles: costCurveImagesTitles,
          paths: costCurveImages,
          appBarImage: 'Cost Curve &#8212; Expected Misclassification Cost',
          buildHyperLink:
              'Built using [ROCR::performance](https://www.rdocumentation.org/packages/ROCR/topics/performance) with measure=ecost.',
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
