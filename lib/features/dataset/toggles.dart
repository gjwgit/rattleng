/// Toggle buttons to process loading of the dataset.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
/// Authors: Graham Williams
library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/data.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/first_start.dart';
import 'package:rattle/providers/keep_in_sync.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This has to be a stateful widget otherwise the buttons don't visually toggle
// i.e., the widget does not seem to get updated even though the values get
// updated.
class DatasetToggles extends ConsumerStatefulWidget {
  const DatasetToggles({super.key});

  @override
  ConsumerState<DatasetToggles> createState() => _DatasetTogglesState();
}

class _DatasetTogglesState extends ConsumerState<DatasetToggles> {
  @override
  void initState() {
    super.initState();

    // Load initial toggle states from SharedPreferences.

    _loadInitialStates();
  }

  Future<void> _loadInitialStates() async {
    // Access the shared preferences instance to load saved settings.

    final prefs = await SharedPreferences.getInstance();

    // Retrieve the "Keep in Sync" setting from shared preferences.
    // Default to `true` if no value is found.

    final keepInSync = prefs.getBool('keepInSync') ?? true;

    // Retrieve the "First Start" state from the provider to determine
    // if this is the first time the app is being initialized.

    final firstStart = ref.read(firstStartProvider);

    // Check if the app is starting for the first time.

    if (firstStart) {
      // Mark the "First Start" as false to prevent this block from
      // executing in subsequent launches.

      ref.read(firstStartProvider.notifier).state = false;

      // Set the initial state of the "Cleanse" toggle based on shared preferences,
      // defaulting to `true` if no value is found.

      ref.read(cleanseProvider.notifier).state =
          prefs.getBool('cleanse') ?? true;

      // Set the initial state of the "Normalise" toggle based on shared preferences,
      // defaulting to `true` if no value is found.

      ref.read(normaliseProvider.notifier).state =
          prefs.getBool('normalise') ?? true;

      // Set the initial state of the "Partition" toggle based on shared preferences,
      // defaulting to `true` if no value is found.

      ref.read(partitionProvider.notifier).state =
          prefs.getBool('partition') ?? true;
    } else {
      // If this is not the first start and "Keep in Sync" is enabled.

      if (keepInSync) {
        // Update the "Cleanse" toggle state to match the value in shared preferences,
        // falling back to the current provider state if no value is found.

        ref.read(cleanseProvider.notifier).state =
            prefs.getBool('cleanse') ?? ref.read(cleanseProvider);

        // Update the "Normalise" toggle state to match the value in shared preferences,
        // falling back to the current provider state if no value is found.

        ref.read(normaliseProvider.notifier).state =
            prefs.getBool('normalise') ?? ref.read(normaliseProvider);

        // Update the "Partition" toggle state to match the value in shared preferences,
        // falling back to the current provider state if no value is found.

        ref.read(partitionProvider.notifier).state =
            prefs.getBool('partition') ?? ref.read(partitionProvider);
      }
    }
  }

  Future<void> _updateSharedPreferences(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    bool validationForTuning = ref.watch(validationForTuningSettingProvider);
    // Watch the "Keep in Sync" state to determine the synchronization behavior.

    final keepInSync = ref.watch(keepInSyncProvider);

    // Declare variables to store the states of the toggles.

    final cleanse;

    final normalise;

    final partition;

    // Check if "Keep in Sync" is enabled.

    if (keepInSync) {
      // If "Keep in Sync" is enabled, use `watch` to ensure
      // the UI is updated whenever the provider states change.

      cleanse = ref.watch(cleanseProvider);

      normalise = ref.watch(normaliseProvider);

      partition = ref.watch(partitionProvider);
    } else {
      // If "Keep in Sync" is disabled, use `read` to access
      // the current values of the providers without subscribing
      // to state changes.

      cleanse = ref.read(cleanseProvider);

      normalise = ref.read(normaliseProvider);

      partition = ref.read(partitionProvider);
    }

    // Return the ToggleButtons widget to display the toggle switches.

    return ToggleButtons(
      // Set the selection states for the toggles based on the provider values.

      isSelected: [cleanse, normalise, partition],

      // Define the behavior when a toggle is pressed.

      onPressed: (int index) {
        // Check if "Keep in Sync" is enabled to determine how to handle state changes.

        if (keepInSync) {
          // If "Keep in Sync" is enabled, update both the provider state
          // and save the changes to shared preferences.

          setState(() {
            switch (index) {
              case 0:
                // Toggle the "Cleanse" state and update shared preferences.

                ref.read(cleanseProvider.notifier).state = !cleanse;

                _updateSharedPreferences('cleanse', !cleanse);

                break;

              case 1:
                // Toggle the "Normalise" state and update shared preferences.

                ref.read(normaliseProvider.notifier).state = !normalise;

                _updateSharedPreferences('normalise', !normalise);

                break;

              case 2:
                // Toggle the "Partition" state and update shared preferences.

                ref.read(partitionProvider.notifier).state = !partition;

                _updateSharedPreferences('partition', !partition);

                break;
            }
          });
        } else {
          // If "Keep in Sync" is disabled, update only the provider state
          // without saving changes to shared preferences.

          setState(() {
            switch (index) {
              case 0:
                // Toggle the "Cleanse" state.

                ref.read(cleanseProvider.notifier).state = !cleanse;

                break;

              case 1:
                // Toggle the "Normalise" state.

                ref.read(normaliseProvider.notifier).state = !normalise;

                break;

              case 2:
                // Toggle the "Partition" state.

                ref.read(partitionProvider.notifier).state = !partition;

                break;
            }
          });
        }
      },

      children: <Widget>[
        // CLEANSE

        MarkdownTooltip(
          message: '''

          **Cleanse** Currently **${cleanse ? "" : "not "}enabled**. When
          enabled a dataset will be cleansed by removing any columns with a
          single constant value and converting character columns with
          $charToFactor or fewer unique values to factors (categoric).  If you
          do not require this automated cleansing of the dataset, disable this
          option.

              ''',
          child: const Icon(Icons.cleaning_services),
        ),

        // UNIFY

        MarkdownTooltip(
          message: '''

          **Unify** Currently **${normalise ? "" : "not "}enabled**. When
          enabled the names of columns (variables) of the dataset are unified by
          converting them to lowercase and separating words by underscore.  If
          you do not require this automated unifying of the variable names,
          disable this option.

          ''',
          child: const Icon(Icons.auto_fix_high_outlined),
        ),

        // PARTITION

        MarkdownTooltip(
          message: '''

          **Partition** Currently **${partition ? "" : "not "}enabled**. When
          enabled, for the purposes of predictive modelling *only*, a dataset
          will be randomly split into three smaller datasets. The three-way
          split defaults to 70/15/15 percent and is currently set as
          70/15/15. Respectively, this creates a **training** dataset (to build
          the model), a **${validationForTuning ? 'validation' : 'tuning'}** dataset (to support
          exploring the model parameters and prevent overfitting), and a
          **testing** dataset (as a hold-out dataset for an unbiased estimate of
          the expected performance of the model). For exploring reasonably large
          datasets (tens of thousands of observations) you can turn partitioning
          off so all data is included in the exploration. For larger datasets
          the partitioning is useful to explore a random subset of the full
          dataset.

          ''',
          child: const Icon(Icons.horizontal_split),
        ),
      ],
    );
  }
}
