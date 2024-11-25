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

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/data.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/first_start.dart';
import 'package:rattle/providers/keep_in_sync.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
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
    final prefs = await SharedPreferences.getInstance();

    final keepInSync = prefs.getBool('keepInSync') ?? true;

    final firstStart = ref.read(firstStartProvider);

    if (firstStart) {
      ref.read(firstStartProvider.notifier).state = false;

      ref.read(cleanseProvider.notifier).state =
          prefs.getBool('cleanse') ?? true;

      ref.read(normaliseProvider.notifier).state =
          prefs.getBool('normalise') ?? true;

      ref.read(partitionProvider.notifier).state =
          prefs.getBool('partition') ?? false;
    } else {
      if (keepInSync) {
        ref.read(cleanseProvider.notifier).state =
            prefs.getBool('cleanse') ?? ref.read(cleanseProvider);

        ref.read(normaliseProvider.notifier).state =
            prefs.getBool('normalise') ?? ref.read(normaliseProvider);

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
    // Watch providers to ensure UI updates.

    final keepInSync = ref.watch(keepInSyncProvider);

    final cleanse;
    final normalise;
    final partition;

    if (keepInSync) {
      cleanse = ref.watch(cleanseProvider);
      normalise = ref.watch(normaliseProvider);
      partition = ref.watch(partitionProvider);
    } else {
      cleanse = ref.read(cleanseProvider);
      normalise = ref.read(normaliseProvider);
      partition = ref.read(partitionProvider);
    }

    return ToggleButtons(
      isSelected: [cleanse, normalise, partition],
      onPressed: (int index) {
        print('keepInSync1: $keepInSync');
        if (keepInSync) {
          setState(() {
            switch (index) {
              case 0:
                ref.read(cleanseProvider.notifier).state = !cleanse;

                _updateSharedPreferences('cleanse', !cleanse);

                break;

              case 1:
                ref.read(normaliseProvider.notifier).state = !normalise;

                _updateSharedPreferences('normalise', !normalise);

                break;

              case 2:
                ref.read(partitionProvider.notifier).state = !partition;

                _updateSharedPreferences('partition', !partition);

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
          enabled, for the purposes of predictive modelling, a dataset will be
          randomly split into three smaller datasets. The three-way split is
          commonly 70/15/15 percent. Respectively, this creates a **training**
          dataset (to build the model), a **tuning** dataset (to assist in
          tuning the model during build and sometimes called a validation
          dataset), and a **testing** dataset (as a hold-out dataset for an
          unbiased estimate of the expected performance of the model). For
          exploring reasonably large datasets (tens of thousands of
          observations) you can turn partitioning off so all data is included in
          the exploration. For larger datasets the partitioning is useful to
          explore a random subset of the full dataset.

          ''',
          child: const Icon(Icons.horizontal_split),
        ),
      ],
    );
  }
}
