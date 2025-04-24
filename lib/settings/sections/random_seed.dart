/// Random seed section.
//
// Time-stamp: <Wednesday 2025-04-09 09:08:55 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Kevin Wang

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/widgets/number_field.dart';

class RandomSeed extends ConsumerWidget {
  final TextEditingController controller;
  const RandomSeed({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomPartition = ref.watch(randomPartitionSettingProvider);

    Future<void> _saveRandomSeed(int value) async {
      final prefs = await SharedPreferences.getInstance();

      // Save "Random Seed" state to preferences.

      await prefs.setInt('randomSeed', value);
    }

    Future<void> _saveRandomPartition(bool value) async {
      final prefs = await SharedPreferences.getInstance();

      // Save "Random Partition" state to preferences.

      await prefs.setBool('randomPartition', value);
    }

    return Column(
      children: [
        Row(
          children: [
            NumberField(
              label: 'Random Seed',
              key: const Key('random_seed_settings'),
              tooltip: '''

              **Random Seed:** The random seed is used to control the randomness
              of partitioning the dataset and building models.  Setting a
              specific seed ensures that results are reproducible. The random
              seed will be reset to this value each tome the dataset is
              partitioned or the model is built.

              ''',
              controller: controller,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: randomSeedSettingProvider,
              sharedPrefsKey: 'randomSeed',
            ),
            configRowGap,
            const Text(
              'Random Partition each Model Build',
              style: TextStyle(fontSize: 16),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Random Seed each Model Build:** When enabled, the dataset
              partition (if any) will be resetrandomised each time a model is built.
              This is useful if you want to ensure that the model is not biased
              towards a specific partition.

              ''',
              child: Switch(
                value: randomPartition,
                onChanged: (value) {
                  ref
                      .read(
                        randomPartitionSettingProvider.notifier,
                      )
                      .state = value;
                  _saveRandomPartition(value);
                },
              ),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Random Seed:**
              Clicking this button resets the random seed to the default value of 42.
              This is useful if you want to restore the initial random state.

              ''',
              child: ElevatedButton(
                onPressed: () {
                  ref.read(randomSeedSettingProvider.notifier).state =
                      defaultRandomSeed;
                  _saveRandomSeed(defaultRandomSeed);

                  ref
                      .read(
                        randomPartitionSettingProvider.notifier,
                      )
                      .state = false;
                  _saveRandomPartition(false);
                },
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
