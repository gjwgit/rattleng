/// Widget to display the Evaluate introduction.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2025-01-14 13:27:09 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

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
// import 'package:rattle/widgets/no_image_page.dart';

/// The EVALUATE panel displays the instructions and then the build output.

class EvaluateDisplay extends ConsumerStatefulWidget {
  const EvaluateDisplay({super.key});

  @override
  ConsumerState<EvaluateDisplay> createState() => _EvaluateDisplayState();
}

class _EvaluateDisplayState extends ConsumerState<EvaluateDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      evaluatePageControllerProvider,
    ); // Get the PageController from Riverpod

    String stdout = ref.watch(stdoutProvider);

    String datasetType = ref.watch(datasetTypeProvider).toUpperCase();
    bool useV = ref.watch(useValidationSettingProvider);
    if (datasetType == 'Tuning' && useV) datasetType = 'Validation';

    List<Widget> pages = [showMarkdownFile(context, evaluateIntroFile)];

    String content = '';

    content = rExtractEvaluate(stdout, datasetType, ref);

    bool showContentMaterial = content.trim().split('\n').length > 1;

    if (showContentMaterial) {
      pages.add(
        TextPage(
          title: '''
                 # Error Matrix\n
                 Built using [errorMatrix::errorMatrix](https://www.rdocumentation.org/packages/rattle/topics/errorMatrix)
                 ''',
          content: '\n$content',
        ),
      );
    }

    String dtype = datasetType.toLowerCase();

    String rocAdaBoostImage = '$tempDir/model_evaluate_roc_adaboost_$dtype.svg';
    String rocCtreeImage = '$tempDir/model_evaluate_roc_ctree_$dtype.svg';
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
    String handRForestImage = '$tempDir/model_evaluate_hand_randomForest_$dtype.svg';
    String handCForestImage = '$tempDir/model_evaluate_hand_cforest_$dtype.svg';
    String handXGBoostImage = '$tempDir/model_evaluate_hand_xgboost_$dtype.svg';
    String handAdaBoostImage = '$tempDir/model_evaluate_hand_adaboost_$dtype.svg';
    String handSVMImage = '$tempDir/model_evaluate_hand_svm_$dtype.svg';
    String handLinearImage = '$tempDir/model_evaluate_hand_linear_$dtype.svg';


    bool treeBoxTicked = ref.watch(treeEvaluateProvider);
    bool forestBoxTicked = ref.watch(forestEvaluateProvider);
    bool boostBoxTicked = ref.watch(boostEvaluateProvider);
    bool svmBoxTicked = ref.watch(svmEvaluateProvider);
    bool neuralBoxTicked = ref.watch(neuralEvaluateProvider);

    List<String> rocImages = [];
    List<String> rocImagesTitles = [];
    List<String> handImages = [];
    List<String> handImagesTitles = [];

    List<String> riskChartImages = [];
    List<String> riskChartImagesTitles = [];

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
      {'image': handSVMImage, 'title': 'SVM', 'ticked': svmBoxTicked},
      {'image': handLinearImage, 'title': 'LINEAR', 'ticked': svmBoxTicked},
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
      {'image': handAdaBoostImage, 'title': 'AdaBoost', 'ticked': boostBoxTicked},
      {'image': handXGBoostImage, 'title': 'XGBoost', 'ticked': boostBoxTicked},
    ];

    // Iterate through each image-title pair.

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

    if (rocImages.isNotEmpty) {
      pages.add(
        MultiImagePage(
          titles: rocImagesTitles,
          paths: rocImages,
          appBarImage:
              'Receiver-Operating Characteristic (ROC) and Area Under the Curve (AUC)',
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
          appBarImage: 'H-Measure --- Coherent Alternative to the AUC',
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

    // 20250105 gjw Considered displaying a No Image Available graphic. Not
    // quite working yet so comment it out for now.
    //
    // } else {
    //   pages.add(NoImagePage());

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
