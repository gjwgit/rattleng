/// Widget to display the Tree introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-11-28 11:36:18 +1100 Graham Williams>
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
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_tree.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

/// The TREE panel displays the tree instructions and then build output.

class TreeDisplay extends ConsumerStatefulWidget {
  const TreeDisplay({super.key});

  @override
  ConsumerState<TreeDisplay> createState() => TreeDisplayState();
}

class TreeDisplayState extends ConsumerState<TreeDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      treePageControllerProvider,
    ); // Get the PageController from Riverpod
    String stdout = ref.watch(stdoutProvider);

    AlgorithmType treeAlgorithm = ref.watch(treeAlgorithmProvider);

    List<Widget> pages = [
      showMarkdownFile(treeIntroFile, context),
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
          title: '# Decision Tree Model\n\n'
              'Built using `rpart()`.\n\n',
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
            title: '# Decision Tree as Rules\n\n'
                'Built using `rattle::asRules()`.\n\n',
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
        ImagePage(
          title: 'Visualising the Tree',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '';

    treeAlgorithm == AlgorithmType.traditional
        ? image = '$tempDir/model_rpart_risk_tr.svg'
        : image = '$tempDir/model_ctree_risk_tr.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Risk Chart --- Optimistic Performance

          Training Dataset

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
        ? image = '$tempDir/model_rpart_risk_tu.svg'
        : image = '$tempDir/model_ctree_risk_tu.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Risk Chart --- Unbiased Estimate of Performance

          Tuning Dataset

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
