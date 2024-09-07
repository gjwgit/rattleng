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

import 'package:rattle/widgets/delayed_tooltip.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';

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
  Widget build(BuildContext context) {
    bool cleanse = ref.read(cleanseProvider);
    bool normalise = ref.read(normaliseProvider);
    bool partition = ref.read(partitionProvider);

    return ToggleButtons(
      isSelected: [cleanse, normalise, partition],
      onPressed: (int index) {
        setState(() {
          switch (index) {
            case 0:
              ref.read(cleanseProvider.notifier).state = !cleanse;
            case 1:
              ref.read(normaliseProvider.notifier).state = !normalise;
            case 2:
              ref.read(partitionProvider.notifier).state = !partition;
          }
        });
      },
      children: const <Widget>[
        // CLEANSE

        DelayedTooltip(
          message: '''

          Cleanse: A CSV dataset is cleaned up by removing constant columns and
          converting character columns to factors (categoric).  If you do not
          require this automated cleansing of the dataset, turn this off.

              ''',
          child: Icon(Icons.cleaning_services),
        ),

        // UNIFY

        DelayedTooltip(
          message: '''

          Unify: Column (variable) names of a CSV dataset are unified by
          converting them to lowercase and separating words by underscore.  If
          you do not require this automated unifying of the variable names, turn
          this off.

          ''',
          child: Icon(Icons.auto_fix_high_outlined),
          // child: Icon(Icons.art_track),
          // child: Icon(Icons.ac_unit),
        ),

        // PARTITION

        DelayedTooltip(
          message: '''

          Partition: A CSV dataset will be split into three smaller datasets,
          with a 70/15/15 split by default, which is common for building
          predictive models. For exploring up to reasonably large datasets (tens
          of thousands of observations) you can turn partitioning off so all
          data is included in the exploration.

          ''',
          child: Icon(Icons.horizontal_split),
          // child: Icon(Icons.assessment_outlined),
        ),
      ],
    );
  }
}
