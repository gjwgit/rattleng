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
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/cluster.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_cluster.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// Define a mapping from type to function name and URL.

final Map<String, Map<String, String>> clusterMethods = {
  'KMeans': {
    'functionName': 'kmeans',
    'functionUrl':
        'https://www.rdocumentation.org/packages/stats/topics/kmeans',
  },
  'Ewkm': {
    'functionName': 'ewkm',
    'functionUrl': 'https://www.rdocumentation.org/packages/wskm',
  },
  'Hierarchical': {
    'functionName': 'hcluster',
    'functionUrl': 'https://www.rdocumentation.org/packages/stats',
  },
  'BiCluster': {
    'functionName': 'biclust',
    'functionUrl': 'https://www.rdocumentation.org/packages/biclust',
  },
};

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
      clusterPageControllerProvider,
    ); // Get the PageController from Riverpod

    String type = ref.read(typeClusterProvider.notifier).state;

    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(clusterIntroFile, context)];

    if (clusterMethods.containsKey(type)) {
      String content = rExtractCluster(stdout, ref);
      if (content.isNotEmpty) {
        // Retrieve the function name and URL from the mapping.

        String functionName = clusterMethods[type]!['functionName']!;
        String functionUrl = clusterMethods[type]!['functionUrl']!;

        pages.add(
          TextPage(
            title: '''

            # Cluster Analysis

            Built using
            [biclust::$functionName()]($functionUrl).

            ''',
            content: '\n$content',
          ),
        );
      }
    }

    String discriminantImage = type == 'KMeans'
        ? '$tempDir/model_cluster_discriminant.svg'
        : type == 'Ewkm'
            ? '$tempDir/model_cluster_ewkm.svg'
            : type == 'Hierarchical'
                ? '$tempDir/model_cluster_hierarchical.svg'
                : '';

    if (imageExists(discriminantImage)) {
      pages.add(
        ImagePage(
          title: '''

          # Cluster Analysis - Visual

          Visit
          [cluster::clusplot()](https://www.rdocumentation.org/packages/stats/topics/kmeans).

          ''',
          path: discriminantImage,
        ),
      );
    }

    if (type == 'Ewkm') {
      String weightImage = '$tempDir/model_cluster_ewkm_weights.svg';
      if (imageExists(weightImage)) {
        pages.add(
          ImagePage(
            title: '''

          # Cluster Analysis - Visual

          Visit
          [cluster::clusplot()](https://www.rdocumentation.org/packages/wskm/topics/ewkm).

          ''',
            path: weightImage,
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
