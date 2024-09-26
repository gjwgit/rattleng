/// Widget to configure the CLUSTER tab: button.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-06-12 12:11:05 +1000 Graham Williams>
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

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/features/cluster/cluster_setting.dart';
import 'package:rattle/providers/cluster_type.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';

/// The CLUSTER tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSouorce.

class ClusterConfig extends ConsumerStatefulWidget {
  const ClusterConfig({super.key});

  @override
  ConsumerState<ClusterConfig> createState() => ClusterConfigState();
}

class ClusterConfigState extends ConsumerState<ClusterConfig> {
  Map<String, String> clusterTypes = {
    'KMeans': '''

      Generate clusters using a kmeans algorithm.

      ''',
    'Ewkm': '''

      Generate clusters using a kmeans algorithm 
      with subspaces selected by entropy weighting.

      ''',
    'Hierarchical': '''

      Build an agglomerative hierarchical cluster.

      ''',
    'BiCluster': '''

      Cluster by identifying suitable subsets of 
      both the variables and the observations.

      ''',
  };
  @override
  Widget build(BuildContext context) {
    String type = ref.read(clusterTypeProvider.notifier).state;

    return Column(
      children: [
        // Space above the beginning of the configs.

        configBotSpace,

        Row(
          children: [
            // Space to the left of the configs.

            configLeftSpace,

            // The BUILD button.

            ActivityButton(
              onPressed: () {
                rSource(context, ref, 'model_template');
                if (type == 'KMeans') {
                  rSource(context, ref, 'model_build_cluster');
                }
              },
              child: const Text('Build Clustering'),
            ),

            configWidgetSpace,

            const Text(
              'Type:',
              style: normalTextStyle,
            ),

            configWidgetSpace,

            ChoiceChipTip<String>(
              options: clusterTypes.keys.toList(),
              selectedOption: type,
              tooltips: clusterTypes,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    type = chosen;
                    ref.read(clusterTypeProvider.notifier).state = chosen;
                  }
                });
              },
            ),
          ],
        ),
        const ClusterSetting(),
      ],
    );
  }
}
