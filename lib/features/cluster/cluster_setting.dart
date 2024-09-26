/// Cluster setting for different cluster types.
///
/// Time-stamp: <Friday 2024-09-27 08:44:19 +1000 Graham Williams>
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
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/cluster_number.dart';
import 'package:rattle/providers/cluster_re_scale.dart';
import 'package:rattle/providers/cluster_run.dart';
import 'package:rattle/providers/cluster_seed.dart';
import 'package:rattle/widgets/delayed_tooltip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
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
        ref.read(clusterNumberProvider.notifier).state.toString();
    _seedController.text =
        ref.read(clusterSeedProvider.notifier).state.toString();
    _runController.text =
        ref.read(clusterRunProvider.notifier).state.toString();

    // Checkbox state.

    bool reScale = ref.read(clusterReScaleProvider.notifier).state;
    return Column(
      children: [
        configTopSpace,
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
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: clusterNumberProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Seed:',
              key: const Key('cluster_seed'),
              tooltip: '''

              The seed is used to re-initiate the random number
              generator. Changing the seed will randomly choose observations to
              initiate the clustering.  To obtain the same results each time use
              the same seed.

              ''',
              controller: _seedController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: clusterSeedProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Runs:',
              key: const Key('cluster_run'),
              tooltip: '''

              The number of random starting partitions to explore when centers
              is a number rather than specific centers. 

              ''',
              controller: _runController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: clusterRunProvider,
            ),
            configWidgetSpace,
            DelayedTooltip(
              message: '''

              Automatically rescale the numeric variables used for cluster
              analysis to be in the range 0-1 to avoid numeric variables with
              large values like 45,325 and 490, overwhelming variables with
              small values like 23, 5, 67.

              ''',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    key: const Key('re_scale'),
                    value: reScale,
                    onChanged: (value) {
                      setState(() {
                        reScale = value!;
                        ref.read(clusterReScaleProvider.notifier).state = value;
                      });
                    },
                  ),
                  const Text(
                    'Re-Scale',
                    style: normalTextStyle,
                  ),
                ],
              ),
            ),
            LabelledCheckbox(
              tooltip: 'TIPPY',
              label: 'RESCALE',
              provider: clusterReScaleProvider,
            ),
          ],
        ),
      ],
    );
  }
}
