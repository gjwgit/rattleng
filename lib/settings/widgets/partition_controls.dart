import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/widgets/setting_number_field.dart';

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
