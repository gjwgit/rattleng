/// Show the settings dialog.
//
// Time-stamp: <Monday 2024-12-23 15:35:05 +1100 Graham Williams>
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

/// GRAPHICS: List of available ggplot themes for the user to choose from.

const List<Map<String, String>> themeOptions = [
  {
    'label': 'Rattle',
    'value': 'theme_rattle',
    'tooltip': 'The default theme used in Rattle.',
  },
  {
    'label': 'Base',
    'value': 'ggthemes::theme_base',
    'tooltip': "A theme based on R's Base plotting system.",
  },
  {
    'label': 'Black and White',
    'value': 'ggplot2::theme_bw',
    'tooltip': '''

        A theme with a white background and black grid lines, often used for
        publication quality plots.

        ''',
  },
  {
    'label': 'Calc',
    'value': 'ggthemes::theme_calc',
    'tooltip': 'A theme based on the Calc spreadsheet.',
  },
  {
    'label': 'Classic',
    'value': 'ggplot2::theme_classic',
    'tooltip': '''

        A theme resembling base R graphics, with a white background and no
        gridlines.

        ''',
  },
  {
    'label': 'Dark',
    'value': 'ggplot2::theme_dark',
    'tooltip': '''

        A theme with a dark background and white grid lines, useful for dark
        mode or high contrast needs.

        ''',
  },
  {
    'label': 'Economist',
    'value': 'ggthemes::theme_economist',
    'tooltip': 'A theme inspired by The Economist journal.',
  },
  {
    'label': 'Excel',
    'value': 'ggthemes::theme_excel',
    'tooltip': 'A theme inspired by the Excel spreadsheet.',
  },
  {
    'label': 'Few',
    'value': 'ggthemes::theme_few',
    'tooltip': "A theme based on Few's work.",
  },
  {
    'label': 'Fivethirtyeight',
    'value': 'ggthemes::theme_fivethirtyeight',
    'tooltip': 'A theme inspired by the FiveThirtyEight website.',
  },
  {
    'label': 'Foundation',
    'value': 'ggthemes::theme_foundation',
    'tooltip': "A theme based on Zurb's Foundation.",
  },
  {
    'label': 'Gdocs',
    'value': 'ggthemes::theme_gdocs',
    'tooltip': 'A theme inspired by Google Docs.',
  },
  {
    'label': 'Grey',
    'value': 'ggplot2::theme_grey',
    'tooltip': 'The default theme of ggplot2, with a grey background.',
  },
  {
    'label': 'Highcharts',
    'value': 'ggthemes::theme_hc',
    'tooltip': 'A theme inspired by Highcharts.',
  },
  {
    'label': 'IGray',
    'value': 'ggthemes::theme_igray',
    'tooltip': 'A minimalist grayscale theme.',
  },
  {
    'label': 'Light',
    'value': 'ggplot2::theme_light',
    'tooltip': 'A theme with a light grey background and white grid lines.',
  },
  {
    'label': 'Linedraw',
    'value': 'ggplot2::theme_linedraw',
    'tooltip':
        'A theme with black and white line drawings, without color shading.',
  },
  {
    'label': 'Minimal',
    'value': 'ggplot2::theme_minimal',
    'tooltip':
        'A minimalistic theme with no background annotations and grid lines.',
  },
  {
    'label': 'Pander',
    'value': 'ggthemes::theme_pander',
    'tooltip': "A theme inspired by Pandoc's pander package.",
  },
  {
    'label': 'Solarized',
    'value': 'ggthemes::theme_solarized',
    'tooltip': 'a theme based on the Solarized color scheme.',
  },
  {
    'label': 'Stata',
    'value': 'ggthemes::theme_stata',
    'tooltip': 'A theme inspired by the Stata software.',
  },
  {
    'label': 'Tufte',
    'value': 'ggthemes::theme_tufte',
    'tooltip': 'A theme inspired by Edward Tufte.',
  },
  {
    'label': 'Void',
    'value': 'ggplot2::theme_void',
    'tooltip': '''

        A completely blank theme, useful for creating annotations or background-less plots

        ''',
  },
  {
    'label': 'Wall Street Journal',
    'value': 'ggthemes::theme_wsj',
    'tooltip': 'A theme inspired by the Wall Street Journal.',
  },
];

void showSettingsDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'Settings',
    barrierDismissible: true,
    barrierColor: Colors.black54, // Darken the background
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return const Align(
        alignment: Alignment.center,
        child: SettingsDialog(),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

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

  Future<void> _saveToggleStates() async {
    final prefs = await SharedPreferences.getInstance();

    // Save the latest provider states to preferences.

    await prefs.setBool('cleanse', ref.read(cleanseProvider));
    await prefs.setBool('normalise', ref.read(normaliseProvider));
    await prefs.setBool('partition', ref.read(partitionProvider));
  }

  void _resetToggleStates() {
    // Reset toggle providers to their defaults by invalidating them.

    ref.invalidate(cleanseProvider);
    ref.invalidate(normaliseProvider);
    ref.invalidate(partitionProvider);
    ref.invalidate(keepInSyncProvider);

    // Save the reset states to preferences.

    _saveToggleStates();
  }

  void resetSessionControl() {
    // Reset session control to default.

    ref.invalidate(askOnExitProvider);

    // Save the reset state to preferences.

    _saveAskOnExit(true);
  }

  Future<void> _saveKeepInSync(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    // Save "Keep in Sync" state to preferences.

    await prefs.setBool('keepInSync', value);
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

    // If the value is false, invalidate the provider to reset the partition values.

    if (!value) {
      ref.invalidate(useValidationSettingProvider);
    }
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

  Future<void> _saveImageViewerApp(String value) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the "imageViewerApp" state to preferences.

    await prefs.setString('imageViewerApp', value);
  }

  Widget _buildImageViewerTextField(BuildContext context, WidgetRef ref) {
    final imageViewerApp = ref.watch(imageViewerSettingProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Image Viewer',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 16),
        // Adjust the width based on font and expected character size

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 150,
          ),
          child: TextField(
            controller: TextEditingController(text: imageViewerApp)
              ..selection =
                  TextSelection.collapsed(offset: imageViewerApp.length),
            onChanged: (value) {
              ref.read(imageViewerSettingProvider.notifier).state = value;

              // Save the new state to shared preferences or other storage as needed.

              _saveImageViewerApp(value);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter image viewer command',
            ),
          ),
        ),
      ],
    );
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
                      // Dataset Toggles section.

                      Divider(),

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
                              'Dataset Toggles',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                              onPressed: _resetToggleStates,
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),

                      configRowGap,

                      // Build toggle rows synced with providers.

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildToggleRow(
                              'Cleanse',
                              cleanse,
                              (value) {
                                ref.read(cleanseProvider.notifier).state =
                                    value;
                                _saveToggleStates();
                              },
                              '''

                              **Cleanse Toggle:**

                              Cleansing prepares the dataset by:

                              - Removing columns with a single constant value.

                              - Converting character columns with limited unique values to categoric factors.

                              Enable for automated cleansing, or disable if not required.

                              ''',
                            ),
                          ),
                          Expanded(
                            child: _buildToggleRow(
                              'Unify',
                              normalise,
                              (value) {
                                ref.read(normaliseProvider.notifier).state =
                                    value;
                                _saveToggleStates();
                              },
                              '''

                              **Unify Toggle:**

                              Unifies dataset column names by:

                              - Converting names to lowercase.

                              - Replacing spaces with underscores.

                              Enable for consistent formatting, or disable if original names are preferred.

                              ''',
                            ),
                          ),
                          Expanded(
                            child: _buildToggleRow(
                              'Partition',
                              partition,
                              (value) {
                                ref.read(partitionProvider.notifier).state =
                                    value;
                                _saveToggleStates();
                              },
                              '''

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
                            child: const Text(
                              'Keep in Sync',
                              style: TextStyle(fontSize: 16),
                            ),
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
                                ref.read(keepInSyncProvider.notifier).state =
                                    value;
                                _saveKeepInSync(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      settingsGroupGap,
                      Divider(),

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

                            **Image Viewer Application Setting:** This setting determines the default
                            command to open image files. The default is "open" on Linux/MacOS and "start"
                            on Windows. You can customise it to match your preferred image viewer.

                            ''',
                            child: const Text(
                              'Image Viewer App',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          configRowGap,

                          // Reset button to restore the default value.

                          MarkdownTooltip(
                            message: '''

                            **Reset Image Viewer App:** Tap here to reset the Image Viewer App setting
                            to the platform's default ("open" on Linux/MacOS, "start" on Windows).

                            ''',
                            child: ElevatedButton(
                              onPressed: () {
                                final defaultApp =
                                    Platform.isWindows ? 'start' : 'open';
                                ref
                                    .read(imageViewerSettingProvider.notifier)
                                    .state = defaultApp;
                              },
                              child: null,
                            ),
                          ),

                          MarkdownTooltip(
                            message: '''

                            **Reset Image Viewer App:** Tap here to reset the Image Viewer App setting
                            to the platform's default ("open" on Linux/MacOS, "start" on Windows).

                            ''',
                            child: ElevatedButton(
                              onPressed: () {
                                final defaultApp =
                                    Platform.isWindows ? 'start' : 'open';
                                ref
                                    .read(imageViewerSettingProvider.notifier)
                                    .state = defaultApp;

                                // Save the reset value.

                                _saveImageViewerApp(defaultApp);
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),

                      configRowGap,

                      // Add the new TextField widget for the Image Viewer App.

                      _buildImageViewerTextField(context, ref),

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

                      _buildPartitionControls(),

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
                      Row(
                        children: [
                          MarkdownTooltip(
                            message: '''

                            **Session Control:** This setting determines whether a confirmation popup
                            appears when the user tries to quit the application.

                            - **ON**: A popup will appear asking the user to confirm quitting.

                            - **OFF**: The application will exit immediately without a confirmation popup.

                            The default setting is **ON**.

                            ''',
                            child: const Text(
                              'Session Control',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          configRowGap,

                          // Restore  button.

                          MarkdownTooltip(
                            message: '''

                            **Reset Session Control:** Tap here to reset to enable a confirmation
                            popup when exiting the application.

                            ''',
                            child: ElevatedButton(
                              onPressed: resetSessionControl,
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),

                      configRowGap,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Ask before exit',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          configRowGap,

                          // Switch for Session Control with a tooltip.

                          MarkdownTooltip(
                            message: '''

                            **Toggle Session Control:**

                            - Slide to **ON** to enable a confirmation popup when exiting the application.

                            - Slide to **OFF** to disable the popup, allowing the app to exit directly.

                            ''',
                            child: Switch(
                              value: askOnExit,
                              onChanged: (value) {
                                ref.read(askOnExitProvider.notifier).state =
                                    value;

                                // Save the new state to shared preferences or other storage as needed.

                                _saveAskOnExit(value);
                              },
                            ),
                          ),
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
                onPressed: _handleCancelButton,
                tooltip: 'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a toggle row with a label and a switch.

  Widget _buildToggleRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    String tooltipMessage, // Tooltip message for the entire row
  ) {
    return MarkdownTooltip(
      message: tooltipMessage,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Custom Text Field widget for integer input.

  Widget _buildCustomNumberField({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    String? tooltip,
  }) {
    final controller = TextEditingController(text: value.toString());

    return MarkdownTooltip(
      message: tooltip ?? '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            child: Focus(
              // Add focus to detect changes when focus is lost.

              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  final input = controller.text;
                  if (input.isNotEmpty) {
                    final parsedValue = int.tryParse(input);
                    if (parsedValue != null) {
                      onChanged(parsedValue);
                    }
                  }
                }
              },
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller,
                onSubmitted: (input) {
                  if (input.isNotEmpty) {
                    final parsedValue = int.tryParse(input);
                    if (parsedValue != null) {
                      onChanged(parsedValue);
                    }
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build partition controls.

  Widget _buildPartitionControls() {
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
            _buildCustomNumberField(
              label: 'Training %:',
              value: train,
              onChanged: (value) async {
                if (value >= 0 && value <= 100) {
                  await _savePartitionTrain(value);
                } else {
                  _showOutOfRangeWarning();
                }
              },
              tooltip: '''

              The percentage of data allocated for training the model. Ensure
              the total across training, ${useValidation ? "validation" : "tuning"}, and testing sums to 100%.

              ''',
            ),
            _buildCustomNumberField(
              label: '${useValidation ? "Validation" : "Tuning"} %:',
              value: tune,
              onChanged: (value) async {
                if (value >= 0 && value <= 100) {
                  await _savePartitionTune(value);
                } else {
                  _showOutOfRangeWarning();
                }
              },
              tooltip: '''

              The percentage of data allocated for ${useValidation ? "validating" : "tuning"} the model. Ensure the total across
              training, ${useValidation ? "validation" : "tuning"}, and testing sums to 100%.

              ''',
            ),
            _buildCustomNumberField(
              label: 'Testing %:',
              value: test,
              onChanged: (value) async {
                if (value >= 0 && value <= 100) {
                  await _savePartitionTest(value);
                } else {
                  _showOutOfRangeWarning();
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
                can choose your preference here.

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
                        ref
                            .read(
                              useValidationSettingProvider.notifier,
                            )
                            .state = value;
                        _saveValidation(value);
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

  /// Display a warning if the partition total is invalid when pressing cancel.

  void _showInvalidPartitionWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Partition Total'),
          content: const Text(
            'The total of Training, Validation, and Testing percentages must be exactly 100.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Validate partition total when pressing cancel button.

  void _handleCancelButton() {
    final train = ref.read(partitionTrainProvider);
    final valid = ref.read(partitionTuneProvider);
    final test = ref.read(partitionTestProvider);
    final total = train + valid + test;

    if (total != 100) {
      _showInvalidPartitionWarning();
    } else {
      Navigator.of(context).pop();
    }
  }

  /// Display a warning if a value is out of the valid range (0-100).

  void _showOutOfRangeWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Values must be between 0 and 100.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
