/// Widget to display the Evaluate introduction.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-12-31 11:58:22 +1100 Graham Williams>
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
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_evaluate.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/multi_image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/text_page.dart';

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

    List<Widget> pages = [showMarkdownFile(context, evaluateIntroFile)];

    String content = '';

    content = rExtractEvaluate(stdout, datasetType, ref);

    bool showContentMaterial = content.trim().split('\n').length > 1;

    if (showContentMaterial) {
      pages.add(
        TextPage(
          title: '# Error Matrix\n\n',
          content: '\n$content',
        ),
      );
    }

    String dtype = datasetType.toLowerCase();

    String rocAdaBoostImage = '$tempDir/model_evaluate_roc_adaboost_$dtype.svg';
    String rocCtreeImage = '$tempDir/model_evaluate_roc_ctree_$dtype.svg';
    String rocNNETImage = '$tempDir/model_evaluate_roc_nnet_$dtype.svg';
    String rocNeuralNetImage = '$tempDir/model_evaluate_roc_neuralnet_$dtype.svg';
    String rocRpartImage = '$tempDir/model_evaluate_roc_rpart_$dtype.svg';
    String rocSVMImage = '$tempDir/model_evaluate_roc_svm_$dtype.svg';
    String rocCforestImage = '$tempDir/model_evaluate_roc_cforest_$dtype.svg';
    String rocRforestImage =
        '$tempDir/model_evaluate_roc_randomForest_$dtype.svg';
    String rocXGBoostImage = '$tempDir/model_evaluate_roc_xgboost_$dtype.svg';

    String handRpartImage = '$tempDir/model_evaluate_hand_rpart_$dtype.svg';
    String handCtreeImage = '$tempDir/model_evaluate_hand_ctree_$dtype.svg';
    String handAdaBoostImage = '$tempDir/model_evaluate_hand_ada_$dtype.svg';

    List<String> existingImages = [];
    List<String> imagesTitles = [];
    List<String> rocImages = [];
    List<String> rocImagesTitles = [];

    // List of image-title pairs for ROC data.

    final rocImageData = [
      {'image': rocAdaBoostImage, 'title': 'AdaBoost'},
      {'image': rocRpartImage, 'title': 'RPART'},
      {'image': rocCtreeImage, 'title': 'CTREE'},
      {'image': rocNNETImage, 'title': 'NNET'},
      {'image': rocNeuralNetImage, 'title': 'NEURALNET'},
      {'image': rocRforestImage, 'title': 'RANDOM FOREST'},
      {'image': rocSVMImage, 'title': 'SVM'},
      {'image': rocCforestImage, 'title': 'CONDITIONAL FOREST'},
      {'image': rocXGBoostImage, 'title': 'XGBoost'},
    ];

    // Iterate through each image-title pair.

    for (var data in rocImageData) {
      if (imageExists(data['image']!)) {
        rocImages.add(data['image']!);
        rocImagesTitles.add(data['title']!);
      }
    }

    if (imageExists(handRpartImage)) {
      existingImages.add(handRpartImage);
      imagesTitles.add('RPART');
    }

    if (imageExists(handCtreeImage)) {
      existingImages.add(handCtreeImage);
      imagesTitles.add('CTREE');
    }

    if (imageExists(handAdaBoostImage)) {
      existingImages.add(handAdaBoostImage);
      imagesTitles.add('ADA BOOST');
    }

    if (rocImages.isNotEmpty) {
      pages.add(
        MultiImagePage(
          titles: rocImagesTitles,
          paths: rocImages,
          appBarImage: 'ROC',
        ),
      );
    }

    if (existingImages.isNotEmpty) {
      pages.add(
        MultiImagePage(
          titles: imagesTitles,
          paths: existingImages,
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
