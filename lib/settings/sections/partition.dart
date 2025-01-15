/// Partition section.
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
import 'package:rattle/settings/widgets/settings_partition_controls.dart';
import 'package:rattle/settings/utils/out_of_range_warning.dart';

class Partition extends ConsumerWidget {
  const Partition({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _savePartitionTrain(int value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('train', value);
      ref.read(partitionTrainProvider.notifier).state = value;
    }

    Future<void> _savePartitionTune(int value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('tune', value);
      ref.read(partitionTuneProvider.notifier).state = value;
    }

    Future<void> _savePartitionTest(int value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('test', value);
      ref.read(partitionTestProvider.notifier).state = value;
    }

    Future<void> _saveValidation(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('useValidation', value);
      ref.read(useValidationSettingProvider.notifier).state = value;
    }

    return Column(
      children: [
        Row(
          children: [
            MarkdownTooltip(
              message: '''
              **Dataset Partition Setting:** Configure the dataset
              partitioning ratios for the training, validation, and
              testing datasets.

              - Default: 70/15/15 (70% training, 15% validation, 15% testing).
              - Customize to suit your dataset requirements, e.g., 50/25/25.
              - The values must sum up to 100%.

              ''',
              child: const Text(
                'Partition',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            configRowGap,
            PartitionControls(
              onTrainChanged: _savePartitionTrain,
              onTuneChanged: _savePartitionTune,
              onTestChanged: _savePartitionTest,
              onValidationChanged: _saveValidation,
              showOutOfRangeWarning: () => showOutOfRangeWarning(context),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Partition Ratios:**
              Reset the dataset partition ratios to the default values of 70/15/15.

              ''',
              child: ElevatedButton(
                onPressed: () async {
                  // Reset the partition values to default.  Save
                  // the new values to shared preferences and
                  // providers.

                  await _savePartitionTrain(70);
                  await _savePartitionTune(15);
                  await _savePartitionTest(15);

                  _saveValidation(false);
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
