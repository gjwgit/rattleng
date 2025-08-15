/// Dataset section.
//
// Time-stamp: "Wednesday 2025-01-15 16:05:18 +1100 Graham Williams"
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
///
///

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/keep_in_sync.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/sections/max_factor.dart';
import 'package:rattle/settings/sections/partition.dart';
import 'package:rattle/settings/sections/random_seed.dart';
import 'package:rattle/settings/widgets/toggle_row.dart';

class DatasetToggles extends ConsumerStatefulWidget {
  const DatasetToggles({super.key});

  @override
  ConsumerState<DatasetToggles> createState() => _DatasetTogglesState();
}

class _DatasetTogglesState extends ConsumerState<DatasetToggles> {
  late final TextEditingController _randomSeedController;
  late final TextEditingController _maxFactorController;

  @override
  void initState() {
    super.initState();
    _randomSeedController = TextEditingController(
      text: ref.read(randomSeedSettingProvider).toString(),
    );
    _maxFactorController = TextEditingController(
      text: ref.read(maxFactorProvider).toString(),
    );
  }

  @override
  void dispose() {
    _randomSeedController.dispose();
    _maxFactorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cleanse = ref.watch(cleanseProvider);
    final normalise = ref.watch(normaliseProvider);
    final partition = ref.watch(partitionProvider);
    final keepInSync = ref.watch(keepInSyncProvider);
    final useValidation = ref.watch(useValidationSettingProvider);

    // Keep the controller in sync with provider if provider changes externally.

    final currentSeed = ref.watch(randomSeedSettingProvider).toString();
    if (_randomSeedController.text != currentSeed) {
      _randomSeedController.text = currentSeed;
    }

    final currentMaxFactor = ref.watch(maxFactorProvider).toString();
    if (_maxFactorController.text != currentMaxFactor) {
      _maxFactorController.text = currentMaxFactor;
    }

    Future<void> saveToggleStates() async {
      final prefs = await SharedPreferences.getInstance();

      // Save the latest provider states to preferences.

      await prefs.setBool('cleanse', ref.read(cleanseProvider));
      await prefs.setBool('normalise', ref.read(normaliseProvider));
      await prefs.setBool('partition', ref.read(partitionProvider));
      await prefs.setInt('maxFactor', ref.read(maxFactorProvider));
      await prefs.setInt('randomSeed', ref.read(randomSeedSettingProvider));
    }

    void resetToggleStates(bool resetMaxFactor, bool resetRandomSeed) {
      // Only reset toggle providers if reset button is not for random seed or max factor.

      if (!resetMaxFactor && !resetRandomSeed) {
        ref.invalidate(cleanseProvider);
        ref.invalidate(normaliseProvider);
        ref.invalidate(partitionProvider);
        ref.invalidate(keepInSyncProvider);
      }

      if (resetMaxFactor) ref.invalidate(maxFactorProvider);
      if (resetRandomSeed) ref.invalidate(randomSeedSettingProvider);

      // Save the reset states to preferences.

      saveToggleStates();
    }

    Future<void> saveKeepInSync(bool value) async {
      final prefs = await SharedPreferences.getInstance();

      // Save "Keep in Sync" state to preferences.

      await prefs.setBool('keepInSync', value);
    }

    return Column(
      children: [
        Row(
          children: [
            MarkdownTooltip(
              message: '''

              **Dataset Toggles Setting:** The default setting of
              the dataset toggles, on starting up Rattle, is set
              here. During a session with Rattle the toggles may be
              changed by the user. If the *Sync* option is set, then
              the changes made by the user are tracked and restored
              on the next time Rattle is run.

              ''',
              child: const Text(
                'Dataset',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            configRowGap,
          ],
        ),

        configRowGap,

        // Build toggle rows synced with providers.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //  Toggles section.
            const Text(
              'Toggles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            configRowGap,

            Expanded(
              child: ToggleRow(
                label: 'Cleanse',
                value: cleanse,
                onChanged: (value) {
                  ref.read(cleanseProvider.notifier).state = value;
                  saveToggleStates();
                },
                tooltipMessage: '''

                **Cleanse Toggle:**

                Cleansing prepares the dataset by:

                - Removing columns with a single constant value.

                - Converting character columns with limited unique values to categoric factors.

                Enable for automated cleansing, or disable if not required.

                ''',
              ),
            ),
            Expanded(
              child: ToggleRow(
                label: 'Unify',
                value: normalise,
                onChanged: (value) {
                  ref.read(normaliseProvider.notifier).state = value;
                  saveToggleStates();
                },
                tooltipMessage: '''

                **Unify Toggle:**

                Unifies dataset column names by:

                - Converting names to lowercase.

                - Replacing spaces with underscores.

                Enable for consistent formatting, or disable if original names are preferred.

                ''',
              ),
            ),
            Expanded(
              child: ToggleRow(
                label: 'Partition',
                value: partition,
                onChanged: (value) {
                  ref.read(partitionProvider.notifier).state = value;
                  saveToggleStates();
                },
                tooltipMessage: '''

                **Partition Toggle:**

                Splits the dataset into subsets for predictive modeling:

                - **Training:** Builds the model.

                - **${useValidation ? 'Validation' : 'Tuning'}:** Tunes the model.

                - **Testing:** Evaluates model performance.

                Enable for larger datasets, or disable for exploratory analysis.

                ''',
              ),
            ),
            MarkdownTooltip(
              message: '''

              **Keep in Sync Toggle:**

              - **On:** Saves toggle changes for current sessions.

              - **Off:** Changes are only recovered on restart.

              ''',
              child: const Text('Keep in Sync', style: TextStyle(fontSize: 16)),
            ),
            MarkdownTooltip(
              message: '''

              **Keep in Sync Toggle:**

              - **On:** Saves toggle changes for current sessions.

              - **Off:** Changes are only recovered on restart.

              ''',
              child: Switch(
                value: keepInSync,
                onChanged: (value) {
                  ref.read(keepInSyncProvider.notifier).state = value;
                  saveKeepInSync(value);
                },
              ),
            ),

            configRowGap,

            // Reset Dataset Toggles to default button.
            MarkdownTooltip(
              message: '''

              **Reset Toggles:** Tap here to reset the Dataset Toggles
                setting to the default for Rattle.

              ''',
              child: ElevatedButton(
                key: const Key('dataset_toggles_reset_button'),
                onPressed: () => resetToggleStates(false, false),
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
        settingsGroupGap,
        RandomSeed(controller: _randomSeedController),

        settingsGroupGap,

        Partition(),
        settingsGroupGap,

        // Ignore Missing Target row.
        Row(
          spacing: configRowSpace,
          children: [
            MarkdownTooltip(
              message: '''
              *Note: This setting is not yet having any effect.*


              **Ignore Missing Target:**

              - **On:** Exclude observations with missing target values from analysis.

              - **Off:** Include all observations, even those with missing target values.
              ''',
              child: Row(
                children: [
                  MaxFactor(controller: _maxFactorController),
                  configRowGap,
                  MarkdownTooltip(
                    message: '''

                    **Reset Toggles:** Tap here to reset the Max Factor to the default value

                    ''',
                    child: ElevatedButton(
                      onPressed: () => resetToggleStates(true, false),
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        settingsGroupGap,

        Divider(),
      ],
    );
  }
}
