/// A Widget to display the tree introduction and then any built tree models.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2025-01-05 19:13:56 +1100 Graham Williams>
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
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/features/tree/rpart_pages.dart';
import 'package:rattle/features/tree/ctree_pages.dart';

/// The Tree panel initially displays the tree introduction and then output for
/// the built models.

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

    AlgorithmType treeAlgorithm = ref.watch(treeAlgorithmProvider);

    // Begin the list of pages to display with the introduction markdown text.

    List<Widget> pages = [
      showMarkdownFile(context, treeIntroFile, 'assets/svg/tree.svg'),
    ];

    // 20250105 gjw Add the appropriate pages for the currently chosen variety
    // of tree algorithm.

    treeAlgorithm == AlgorithmType.traditional
        ? pages.addAll(rpartPages(ref))
        : pages.addAll(ctreePages(ref));

    // 20250105 gjw Return the PageViewer widget for navigating through the
    // model pages.

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
