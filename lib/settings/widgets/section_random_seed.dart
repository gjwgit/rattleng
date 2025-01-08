import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/widgets/repeat_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
        configRowGap,
        Row(
          children: [
            RandomSeedRow(
              randomSeed: randomSeed,
              updateSeed: (newSeed) {
                ref.read(randomSeedSettingProvider.notifier).state = newSeed;
                _saveRandomSeed(newSeed);
              },
            ),
            MarkdownTooltip(
              message: '''



              ''',
              child: const Text(
                'Random Partition each Model Build',
                style: TextStyle(fontSize: 16),
              ),
            ),
            MarkdownTooltip(
              message: '''



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
          ],
        ),
        settingsGroupGap,
        const Divider(),
      ],
    );
  }
}
