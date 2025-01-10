/// Partition controls.
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

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/widgets/settings_number_field.dart';

class PartitionControls extends ConsumerWidget {
  final Function(int) onTrainChanged;
  final Function(int) onTuneChanged;
  final Function(int) onTestChanged;
  final Function(bool) onValidationChanged;
  final Function() showOutOfRangeWarning;

  const PartitionControls({
    super.key,
    required this.onTrainChanged,
    required this.onTuneChanged,
    required this.onTestChanged,
    required this.onValidationChanged,
    required this.showOutOfRangeWarning,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final train = ref.watch(partitionTrainProvider);
    final tune = ref.watch(partitionTuneProvider);
    final test = ref.watch(partitionTestProvider);
    final useValidation = ref.watch(useValidationSettingProvider);
    final total = train + tune + test;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: configRowSpace,
          children: [
            SettingNumberField(
              label: 'Training %:',
              value: train,
              onChanged: (value) async {
                if (value >= 0 && value <= 100) {
                  onTrainChanged(value);
                } else {
                  showOutOfRangeWarning();
                }
              },
              tooltip: '''

              The percentage of data allocated for training the model. Ensure
              the total across training, ${useValidation ? "validation" : "tuning"}, and testing sums to 100%.

              ''',
            ),
            SettingNumberField(
              label: '${useValidation ? "Validation" : "Tuning"} %:',
              value: tune,
              onChanged: (value) async {
                if (value >= 0 && value <= 100) {
                  onTuneChanged(value);
                } else {
                  showOutOfRangeWarning();
                }
              },
              tooltip: '''

              The percentage of data allocated for ${useValidation ? "validating" : "tuning"} the model. Ensure the total across
              training, ${useValidation ? "validation" : "tuning"}, and testing sums to 100%.

              ''',
            ),
            SettingNumberField(
              label: 'Testing %:',
              value: test,
              onChanged: (value) async {
                if (value >= 0 && value <= 100) {
                  onTestChanged(value);
                } else {
                  showOutOfRangeWarning();
                }
              },
              tooltip: '''

              The percentage of data allocated for testing the model. Ensure the total
              across training, ${useValidation ? "validation" : "tuning"}, and testing sums to 100%.

              ''',
            ),
            Text(
              'Total: $total%',
              style: TextStyle(
                fontSize: 16,
                color: total == 100 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              child: MarkdownTooltip(
                message: '''

                Some data scientists think of the second dataset of the
                partitions as a dataset to use for **tuning** the model. Others
                see it as a dataset for **validating** parameter settings. You
                can choose your preference for the nomenclature here. The choice
                does not have any material impact on any analysis.
                
                ''',
                child: Row(
                  children: [
                    const Text(
                      'Use Tuning',
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: useValidation,
                      onChanged: (value) {
                        onValidationChanged(value);
                      },
                    ),
                    const Text(
                      'or Validation',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
