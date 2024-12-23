/// Widget to display the Tree introduction, the built tree, and evaluation.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-12-23 15:33:14 +1100 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_tree.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/single_image_page.dart';
import 'package:rattle/widgets/text_page.dart';

/// The Tree panel displays the tree instructions and then output for the built
/// model.

class TreeDisplay extends ConsumerStatefulWidget {
  const TreeDisplay({super.key});

  @override
  ConsumerState<TreeDisplay> createState() => _TreeDisplayState();
}

class _TreeDisplayState extends ConsumerState<TreeDisplay> {
  @override
  Widget build(BuildContext context) {
    // Get the PageController from Riverpod.

    final pageController = ref.watch(
      treePageControllerProvider,
    );

    bool useValidation = ref.watch(useValidationSettingProvider);

    String stdout = ref.watch(stdoutProvider);

    AlgorithmType treeAlgorithm = ref.watch(treeAlgorithmProvider);

    // Begin the list of pages to display with the introduction markdown text.

    List<Widget> pages = [
      showMarkdownFile(context, treeIntroFile, 'assets/svg/tree.svg'),
    ];

    String content = '';

    ////////////////////////////////////////////////////////////////////////

    // Default tree text.

    treeAlgorithm == AlgorithmType.traditional
        ? content = rExtractTree(stdout)
        : content = rExtract(stdout, 'print(model_ctree)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Decision Tree Model

          Built using [rpart::rpart()](https://www.rdocumentation.org/packages/rpart/topics/rpart).

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // Convert to rules.

    if (treeAlgorithm == AlgorithmType.traditional) {
      content = rExtract(stdout, 'asRules(model_rpart)');

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: '''

            # Decision Tree as Rules

            Built using [rattle::asRules()](https://www.rdocumentation.org/packages/rattle/topics/asRules).

            ''',
            content: '\n$content',
          ),
        );
      }
    }

    ////////////////////////////////////////////////////////////////////////

    String image = '';

    treeAlgorithm == AlgorithmType.traditional
        ? image = '$tempDir/model_tree_rpart.svg'
        : image = '$tempDir/model_tree_ctree.svg';

    if (imageExists(image)) {
      pages.add(
        SingleImagePage(
          title: '''

          # Decision Tree Visualisation

          Built using
          [rattle::fancyRpartPlot()](https://www.rdocumentation.org/packages/rattle/topics/fancyRpartPlot).

          ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '';

    treeAlgorithm == AlgorithmType.traditional
        ? image = '$tempDir/model_rpart_riskchart_training.svg'
        : image = '$tempDir/model_ctree_riskchart_training.svg';

    if (imageExists(image)) {
      pages.add(
        SingleImagePage(
          title: '''

          # Risk Chart &#8212; Optimistic Estimate of Performance

          Using the **training** dataset to evaluate the model performance.

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/decision-tree-performance.html) and
          [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).
            ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '';

    treeAlgorithm == AlgorithmType.traditional
        ? image = '$tempDir/model_rpart_riskchart_tuning.svg'
        : image = '$tempDir/model_ctree_riskchart_tuning.svg';

    if (imageExists(image)) {
      pages.add(
        SingleImagePage(
          title: '''

          # Risk Chart &#8212; Unbiased Estimate of Performance

          Using the **${useValidation ? 'validation' : 'tuning'}** dataset to
          evaluate the model performance.

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/decision-tree-performance.html) and
          [rattle::riskchart()](https://www.rdocumentation.org/packages/rattle/topics/riskchart).

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
