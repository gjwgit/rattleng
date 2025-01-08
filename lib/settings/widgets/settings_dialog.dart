/// Show the settings dialog.
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
/// Authors: Graham Williams, Kevin Wang

library;

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/settings.dart';
import 'package:rattle/settings/utils/out_of_range_warning.dart';
import 'package:rattle/settings/widgets/dataset_toggles.dart';
import 'package:rattle/settings/widgets/image_viewer_text_field.dart';
import 'package:rattle/settings/utils/save_image_viewer_app.dart';
import 'package:rattle/settings/widgets/partition_controls.dart';
import 'package:rattle/settings/widgets/toggle_row.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/keep_in_sync.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/session_control.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/repeat_button.dart';
import 'package:rattle/settings/utils/handle_cancel_button.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends ConsumerState<SettingsDialog> {
  String? _selectedTheme;

  @override
  void initState() {
    super.initState();

    // Get the current theme from the Riverpod provider.

    _selectedTheme = ref.read(settingsGraphicThemeProvider);

    // Automatically update the theme in Riverpod when the dialog is opened.

    ref
        .read(settingsGraphicThemeProvider.notifier)
        .setGraphicTheme(_selectedTheme!);

    // Load toggle states and "Keep in Sync" state from shared preferences.

    _loadSettings();

    _loadRandomSeed();

    _loadPartition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Update providers with saved toggle states.

    ref.read(cleanseProvider.notifier).state =
        prefs.getBool('cleanse') ?? ref.read(cleanseProvider);

    ref.read(normaliseProvider.notifier).state =
        prefs.getBool('normalise') ?? ref.read(normaliseProvider);

    ref.read(partitionProvider.notifier).state =
        prefs.getBool('partition') ?? ref.read(partitionProvider);

    // Update "Keep in Sync" state.

    ref.read(keepInSyncProvider.notifier).state =
        prefs.getBool('keepInSync') ?? true;

    // Update "Session Control" state.

    ref.read(askOnExitProvider.notifier).state =
        prefs.getBool('askOnExit') ?? true;

    final platformDefault = Platform.isWindows ? 'start' : 'open';

    // Set initial value if the provider state is empty.

    ref.read(imageViewerSettingProvider.notifier).state =
        prefs.getString('imageViewerApp') ?? platformDefault;

    ref.read(randomPartitionSettingProvider.notifier).state =
        prefs.getBool('randomPartition') ?? false;

    ref.read(useValidationSettingProvider.notifier).state =
        prefs.getBool('useValidation') ?? false;
  }

  void resetSessionControl() {
    // Reset session control to default.

    ref.invalidate(askOnExitProvider);

    // Save the reset state to preferences.

    _saveAskOnExit(true);

    // Reset the image viewer app to the platform default.

    final defaultApp = Platform.isWindows ? 'start' : 'open';
    ref.read(imageViewerSettingProvider.notifier).state = defaultApp;

    // Save the reset value.

    saveImageViewerApp(defaultApp);
  }

  Future<void> _saveRandomPartition(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    // Save "Random Partition" state to preferences.

    await prefs.setBool('randomPartition', value);
  }

  Future<void> _saveValidation(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    // Save "Validation than Tuning" state to preferences.

    await prefs.setBool('useValidation', value);

    // Update the provider state.

    ref.read(useValidationSettingProvider.notifier).state = value;
  }

  Future<void> _saveAskOnExit(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    // Save "askOnExit" state to preferences.

    await prefs.setBool('askOnExit', value);
  }

  Future<void> _loadRandomSeed() async {
    final prefs = await SharedPreferences.getInstance();
    final seed = prefs.getInt('randomSeed') ?? 42;
    ref.read(randomSeedSettingProvider.notifier).state = seed;
  }

  Future<void> _loadPartition() async {
    final prefs = await SharedPreferences.getInstance();
    final train = prefs.getInt('train') ?? 70;
    ref.read(partitionTrainProvider.notifier).state = train;

    final tune = prefs.getInt('tune') ?? 15;
    ref.read(partitionTuneProvider.notifier).state = tune;

    final test = prefs.getInt('test') ?? 15;
    ref.read(partitionTestProvider.notifier).state = test;
  }

  /// Save training partition percentage.

  Future<void> _savePartitionTrain(int value) async {
    // Save the new state to shared preference.

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('train', value);

    // Update the provider state.

    ref.read(partitionTrainProvider.notifier).state = value;
  }

  /// Save validation partition percentage.

  Future<void> _savePartitionTune(int value) async {
    // Save the new state to shared preference.

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('tune', value);

    // Update the provider state.

    ref.read(partitionTuneProvider.notifier).state = value;
  }

  /// Save testing partition percentage.

  Future<void> _savePartitionTest(int value) async {
    // Save the new state to shared preference.

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('test', value);

    // Update the provider state.

    ref.read(partitionTestProvider.notifier).state = value;
  }

  Future<void> _saveRandomSeed(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('randomSeed', value);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Watch provider values to ensure UI stays in sync.

    final cleanse = ref.watch(cleanseProvider);
    final normalise = ref.watch(normaliseProvider);
    final partition = ref.watch(partitionProvider);
    final keepInSync = ref.watch(keepInSyncProvider);
    final askOnExit = ref.watch(askOnExitProvider);

    final randomSeed = ref.watch(randomSeedSettingProvider);
    final randomPartition = ref.watch(randomPartitionSettingProvider);

    final useValidation = ref.watch(useValidationSettingProvider);

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(),

                      DatasetToggles(),

                      Row(
                        children: [
                          MarkdownTooltip(
                            message: '''

                            **Graphic Theme Setting:** The graphic theme is used
                            by many (but not all) of the plots in Rattle, and
                            specifically by those plots using the ggplot2
                            package. Hover over each theme for more details. The
                            default is the Rattle theme.

                            ''',
                            child: Text(
                              'Graphic Theme',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          configRowGap,

                          // Restore default theme button.

                          MarkdownTooltip(
                            message: '''

                            **Reset Theme:** Tap here to reset the Graphic Theme
                              setting to the default theme for Rattle.

                            ''',
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedTheme = 'theme_rattle';
                                });

                                ref
                                    .read(settingsGraphicThemeProvider.notifier)
                                    .setGraphicTheme(_selectedTheme!);

                                rSource(context, ref, ['settings']);
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),

                      configRowGap,
                      // Theme selection chips.

                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: themeOptions.map((option) {
                          return MarkdownTooltip(
                            message: option['tooltip']!,
                            child: ChoiceChip(
                              label: Text(option['label']!),
                              selected: _selectedTheme == option['value'],
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedTheme = option['value'];
                                });

                                ref
                                    .read(settingsGraphicThemeProvider.notifier)
                                    .setGraphicTheme(_selectedTheme!);

                                rSource(context, ref, ['settings']);
                              },
                            ),
                          );
                        }).toList(),
                      ),

                      settingsGroupGap,
                      Divider(),

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
                        showOutOfRangeWarning: () =>
                            showOutOfRangeWarning(context),
                      ),

                      settingsGroupGap,
                      Divider(),
                      // Random Seed Section.

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
                                ref
                                    .read(randomSeedSettingProvider.notifier)
                                    .state = 42;
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
                        spacing: 10,
                        children: [
                          RandomSeedRow(
                            randomSeed: randomSeed,
                            updateSeed: (newSeed) {
                              ref
                                  .read(randomSeedSettingProvider.notifier)
                                  .state = newSeed;
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
                      Divider(),

                      // Session settings (Ask before exit and Image Viewer App).

                      Row(
                        children: [
                          // Session settings header.

                          const Text(
                            'Session',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          configRowGap,

                          // Restore  button.

                          MarkdownTooltip(
                            message: '''

                            **Reset Session Control:** Tap here to reset to enable a confirmation
                            popup when exiting the application.


                            **Reset Image Viewer App:** Tap here to reset the Image Viewer App setting
                            to the platform's default ("open" on Linux/MacOS, "start" on Windows).

                            ''',
                            child: ElevatedButton(
                              onPressed: resetSessionControl,
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),

                      configRowGap,

                      // Ask before exit and image viewer  settings.

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MarkdownTooltip(
                            message: '''

                            **Session Control:** This setting determines whether a confirmation popup
                            appears when the user tries to quit the application.

                            - **ON**: A popup will appear asking the user to confirm quitting.

                            - **OFF**: The application will exit immediately without a confirmation popup.

                            The default setting is **ON**.

                            ''',
                            child: Row(
                              children: [
                                const Text(
                                  'Ask before exit',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),

                                configRowGap,

                                // Switch for Ask before exit.

                                Switch(
                                  value: askOnExit,
                                  onChanged: (value) {
                                    ref.read(askOnExitProvider.notifier).state =
                                        value;

                                    // Save the new state to shared preferences.

                                    _saveAskOnExit(value);
                                  },
                                ),
                              ],
                            ),
                          ),

                          configRowGap,

                          // The new TextField widget for the Image Viewer.
                          const ImageViewerTextField(),
                        ],
                      ),

                      settingsGroupGap,
                    ],
                  ),
                ),
              ),
            ),

            // Close button for the dialog.

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => handleCancelButton(context, ref),
                tooltip: 'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
