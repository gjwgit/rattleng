/// Cluster setting for different cluster types.
///
/// Time-stamp: <Friday 2024-09-27 10:28:59 +1000 Graham Williams>
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/cluster.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/number_field.dart';

class ClusterSetting extends ConsumerStatefulWidget {
  const ClusterSetting({super.key});

  @override
  ConsumerState<ClusterSetting> createState() => _ClusterSettingState();
}

class _ClusterSettingState extends ConsumerState<ClusterSetting> {
  // Controllers for the input fields.

  final TextEditingController _clusterController = TextEditingController();
  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _runController = TextEditingController();
  final TextEditingController _processorController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _clusterController.dispose();
    _seedController.dispose();
    _runController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clusterController.text =
        ref.read(numberClusterProvider.notifier).state.toString();
    _seedController.text =
        ref.read(randomSeedProvider.notifier).state.toString();
    _runController.text =
        ref.read(runClusterProvider.notifier).state.toString();

    // Data points distance.

    List<String> distance = [
      'euclidean',
      'maximum',
      'manhattan',
      'canberra',
      'binary',
      'pearson',
      'correlation',
      'spearman',
    ];
    List<String> link = [
      'ward',
      'single',
      'complete',
      'average',
      'mcquitty',
      'median',
      'centroid',
      'centroid2',
    ];
    String selectedDistance = ref.watch(distanceClusterProvider);
    String selectedLink = ref.watch(linkClusterProvider);
    String type = ref.watch(typeClusterProvider);

    return Column(
      children: [
        configTopGap,
        Row(
          children: [
            NumberField(
              label: 'Clusters:',
              key: const Key('cluster_number'),
              tooltip: '''

              The number of clusters (k) or a set of initial (distinct) cluster
              centers.

              ''',
              controller: _clusterController,
              enabled: type != 'Hierarchical',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: numberClusterProvider,
            ),
            configWidgetGap,
            NumberField(
              label: 'Seed:',
              key: const Key('random_seed'),
              tooltip: '''

              The seed is used to re-initiate the random number
              generator. Changing the seed will randomly choose observations to
              initiate the clustering.  To obtain the same results each time use
              the same seed.

              ''',
              controller: _seedController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: randomSeedProvider,
            ),
            configWidgetGap,
            NumberField(
              label: 'Runs:',
              key: const Key('cluster_run'),
              tooltip: '''

              The number of random starting partitions to explore when centers
              is a number rather than specific centers. 

              ''',
              controller: _runController,
              enabled: type != 'Hierarchical' && type != 'BiCluster',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: runClusterProvider,
            ),
            configWidgetGap,
            NumberField(
              label: 'Processors:',
              key: const Key('cluster_processor'),
              tooltip: '''
              
              Integer, number of subprocess for parallelization.

              ''',
              controller: _processorController,
              enabled: type == 'Hierarchical',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: processorClusterProvider,
            ),
            configWidgetGap,
            variableChooser(
              'Distance',
              distance,
              selectedDistance,
              ref,
              distanceClusterProvider,
              tooltip: '''

              Distance measures how similar or dissimilar data points are, 
              determining how they are grouped together in clusters.

              ''',
              enabled: type == 'Hierarchical',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(distanceClusterProvider.notifier).state = value;
                }
              },
            ),
            configWidgetGap,
            variableChooser(
              'Link',
              link,
              selectedLink,
              ref,
              linkClusterProvider,
              tooltip: '''

              A link determines how the distance between clusters is calculated 
              when merging them, influencing the shape and structure of the resulting clusters.

              ''',
              enabled: type == 'Hierarchical',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(linkClusterProvider.notifier).state = value;
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
