/// Random seed section.
//
// Time-stamp: <Monday 2025-01-06 15:20:25 +1100 Graham Williams>
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/widgets/repeat_button.dart';

class RandomSeed extends ConsumerWidget {
  const RandomSeed({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomSeed = ref.watch(randomSeedSettingProvider);
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
            // Title.

            MarkdownTooltip(
              message: '''

              **Random Seed Setting:**
              The random seed is used to control the randomness.
              Setting a specific seed ensures that results are reproducible.

              - **Default Seed:** The default seed is 42.
              - **Reset:** Use the "Reset" button to restore the default seed.

              ''',
              child: const Text(
                'Random Seed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            configRowGap,
            RandomSeedRow(
              randomSeed: randomSeed,
              updateSeed: (newSeed) {
                ref.read(randomSeedSettingProvider.notifier).state = newSeed;
                _saveRandomSeed(newSeed);
              },
            ),
            configRowGap,

            MarkdownTooltip(
              message: '''



              ''',
              child: const Text(
                'Random Partition each Model Build',
                style: TextStyle(fontSize: 16),
              ),
            ),
            configRowGap,

            MarkdownTooltip(
              message: '''

              **Random Partition each Model Build:**
              When enabled, the partition will be randomised each time a model is built.
              This is useful if you want to ensure that the model is not biased towards a specific partition.

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
                  ref.read(randomSeedSettingProvider.notifier).state = 42;
                  _saveRandomSeed(42);

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
