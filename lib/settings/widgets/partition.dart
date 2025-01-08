import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/widgets/partition_controls.dart';
import 'package:rattle/settings/utils/out_of_range_warning.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        configRowGap,
        PartitionControls(
          onTrainChanged: _savePartitionTrain,
          onTuneChanged: _savePartitionTune,
          onTestChanged: _savePartitionTest,
          onValidationChanged: _saveValidation,
          showOutOfRangeWarning: () => showOutOfRangeWarning(context),
        ),
        settingsGroupGap,
        const Divider(),
      ],
    );
  }
}
