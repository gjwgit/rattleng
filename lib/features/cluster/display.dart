/// Widget to display the Cluster introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-09-26 11:13:34 +1000 Graham Williams>
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
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_cluster.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The CLUSTER panel displays the tree instructions or the tree biuld output.

class ClusterDisplay extends ConsumerStatefulWidget {
  const ClusterDisplay({super.key});

  @override
  ConsumerState<ClusterDisplay> createState() => _ClusterDisplayState();
}

class _ClusterDisplayState extends ConsumerState<ClusterDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
        clusterPageControllerProvider); // Get the PageController from Riverpod

    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(clusterIntroFile, context)];

    String content = rExtractCluster(stdout, ref);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Cluster Analysis

          Built using
          [stats::kmeans()](https://www.rdocumentation.org/packages/stats/topics/kmeans).

          ''',
          content: '\n$content',
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
