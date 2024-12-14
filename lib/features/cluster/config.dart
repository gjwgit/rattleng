/// Widget to configure the CLUSTER tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-12-14 21:26:13 +1100 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/features/cluster/settings.dart';
import 'package:rattle/providers/cluster.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';

/// A StatefulWidget to pass the ref across to the rSouorce.

class ClusterConfig extends ConsumerStatefulWidget {
  const ClusterConfig({super.key});

  @override
  ConsumerState<ClusterConfig> createState() => ClusterConfigState();
}

class ClusterConfigState extends ConsumerState<ClusterConfig> {
  // 'Hierarchical' and 'BiCluster' are not implemented.

  Map<String, String> clusterTypes = {
    'KMeans': '''

      Generate clusters using a kmeans algorithm, a traditional cluster
      algorithm used in statistics.

      ''',
    'Ewkm': '''

      Generate clusters using a kmeans algorithm initialised by selecting
      subspaces using entropy weighting.

      ''',
    'Hierarchical': '''

      Build an agglomerative hierarchical cluster.

      ''',
    'BiCluster': '''

      Cluster by identifying suitable subsets of both the variables and the
      observations, rather than just the observations as in kmeans.

      ''',
  };

  @override
  Widget build(BuildContext context) {
    String type = ref.read(typeClusterProvider.notifier).state;

    return Column(
      spacing: configRowSpace,
      children: [
        configTopGap,
        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            ActivityButton(
              tooltip: '''

              Tap to build a $type cluster model using the parameter values that
              are set here.

              ''',
              onPressed: () async {
                // Identify the R scripts to run for the vcarious choices of
                // cluster analysis.

                String mt = 'model_template';
                String km = 'model_build_cluster_kmeans';
                String ew = 'model_build_cluster_ewkm';
                String hi = 'model_build_cluster_hierarchical';
                String bi = 'model_build_cluster_bicluster';

                if (type == 'KMeans') {
                  if (context.mounted) await rSource(context, ref, [mt, km]);
                } else if (type == 'Ewkm') {
                  if (context.mounted) await rSource(context, ref, [mt, ew]);
                } else if (type == 'Hierarchical') {
                  if (context.mounted) await rSource(context, ref, [mt, hi]);
                } else if (type == 'BiCluster') {
                  if (context.mounted) await rSource(context, ref, [mt, bi]);
                }

                await ref.read(clusterPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build Clustering'),
            ),
            ChoiceChipTip<String>(
              options: clusterTypes.keys.toList(),
              selectedOption: type,
              tooltips: clusterTypes,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    type = chosen;
                    ref.read(typeClusterProvider.notifier).state = chosen;
                  }
                });
              },
            ),
            configWidgetGap,
            LabelledCheckbox(
              key: const Key('re_scale'),
              tooltip: '''

              Distance based cluster analysis is heavily affected by variables
              with larger magnitudes (like salary, e.g., 45,000 and 50,000 has a
              distance of 5,000) compared to those with smaller magnitudes (like
              age, e.g., 45 and 50 has a distance of 5). We enable Re-Scaling by
              default to avoid this issue on distance based clustering by
              rescaling all values to be between 0 and 1.

              ''',
              label: 'Re-Scale',
              enabled: type != 'Hierarchical',
              provider: reScaleClusterProvider,
            ),
          ],
        ),
        const ClusterSetting(),
      ],
    );
  }
}
