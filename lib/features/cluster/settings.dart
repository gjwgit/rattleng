/// Cluster setting for different cluster types.
///
/// Time-stamp: "Saturday 2025-04-19 14:34:58 +1000 Graham Williams"
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/cluster.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
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
        ref.read(randomSeedSettingProvider.notifier).state.toString();
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

    bool randomPartition = ref.watch(partitionProvider);

    String stdout = ref.watch(stdoutProvider);

    String nobs = rExtract(stdout, '> nobs').split(' ').last;

    // Convert nobs to integer if possible.

    int? nobsInt;
    if (nobs.isNotEmpty) {
      try {
        nobsInt = int.parse(nobs);
        if (randomPartition) {
          int partitionPercent = ref.watch(partitionTrainProvider);
          nobsInt = (nobsInt * partitionPercent) ~/ 100;
        }
      } catch (e) {
        // Keep nobsInt as null if parsing fails.
      }
    }

    return Column(
      children: [
        configTopGap,
        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            NumberField(
              label: 'Clusters:',
              key: const Key('cluster_number'),
              tooltip: '''

              **Clusters:** Set the number of clusters (k) you would like to
              create from the dataset. For the K-Means algorithm the k clusters
              will be initialised from a random selection of k observations
              (rows) from the dataset. The value must be less than the number of
              rows in the dataset ${nobsInt ?? ""}.

              ''',
              controller: _clusterController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(
                value,
                min: 1,
                max: nobsInt != null && nobsInt > 1 ? nobsInt - 1 : null,
              ),
              stateProvider: numberClusterProvider,
            ),
            NumberField(
              label: 'Seed:',
              key: const Key('random_seed'),
              tooltip: '''

              **Seed:** Set a number to initialise/reset the random number
              generator. Changing the seed will result in different observations
              being chosen to initialise the K-Means clustering.  To obtain the
              same results each time use the same seed. The value of the seed is
              remembered between sessions. You can also set the value of the
              seed under the **Settings** button.

              Note that a random seed is not utilised for the **Hierarchical**
              algorithm.

              ''',
              controller: _seedController,
              enabled: type != 'Hierarchical',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: randomSeedSettingProvider,
            ),
            NumberField(
              label: 'Runs:',
              key: const Key('cluster_run'),
              tooltip: '''

              **Runs:** Set the number of random starting partitions to
              explore. The best clustering will be chosen from among those
              built.

              ''',
              controller: _runController,
              enabled: type != 'Hierarchical' && type != 'BiCluster',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: runClusterProvider,
            ),
            NumberField(
              label: 'Processors:',
              key: const Key('cluster_processor'),
              tooltip: '''

              **Processors:** Set as an integer the number of subprocess for
                parallelization.

              ''',
              controller: _processorController,
              enabled: type == 'Hierarchical',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: processorClusterProvider,
            ),
            variableChooser(
              'Distance',
              distance,
              selectedDistance,
              ref,
              distanceClusterProvider,
              tooltip: '''

              **Distance:** For the **Hierachical** algorithm choose a preferred
              alogirthm for measuring the similarity/distance between
              observations, and so determining how well they are grouped
              together in clusters.

              ''',
              enabled: type == 'Hierarchical',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(distanceClusterProvider.notifier).state = value;
                }
              },
            ),
            variableChooser(
              'Link',
              link,
              selectedLink,
              ref,
              linkClusterProvider,
              tooltip: '''

              **Link:** For the **Hierachical** algorithm choose a method for
              determining how the distance between clusters is calculated when
              merging them, influencing the shape and structure of the resulting
              clusters.

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
