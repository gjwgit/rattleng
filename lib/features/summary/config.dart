/// Widget to configure the SUMMARY tab with a button to generate the summary.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-10-05 11:12:15 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/page_controller.dart';

import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/delayed_tooltip.dart';

/// The SUMMARY tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class SummaryConfig extends ConsumerStatefulWidget {
  const SummaryConfig({super.key});

  @override
  ConsumerState<SummaryConfig> createState() => SummaryConfigState();
}

class SummaryConfigState extends ConsumerState<SummaryConfig> {
  // Toggles for the different summary features.
  List<String> summaryOptions = [
    'SUMMARY',
    'SKIM',
    'SPREAD',
    'CROSS TAB',
  ];

  Map<String, bool> selectedOptions = {
    'SUMMARY': true,
    'SKIM': true,
    'SPREAD': true,
    'CROSS TAB': false, // CROSS TAB is expensive, so it defaults to false.
  };

  // Tooltips for each option
  Map<String, String> optionTooltips = {
    'SUMMARY': 'Generate the summary of the dataset.',
    'SKIM': 'Perform a skim summary for an overview of variables.',
    'SPREAD': 'Spread categorical variables.',
    'CROSS TAB': 'Generate a cross-tabulation (can be expensive).',
  };

  Widget summaryToggles() {
    return Expanded(
      child: Wrap(
        spacing: 5.0,
        runSpacing: choiceChipRowSpace,
        children: summaryOptions.map((option) {
          return DelayedTooltip(
            message: optionTooltips[option]!,
            child: FilterChip(
              label: Text(option),
              selectedColor: Colors.lightBlue[200],
              showCheckmark: false,
              backgroundColor: selectedOptions[option]!
                  ? Colors.lightBlue[50]
                  : Colors.grey[300],
              shadowColor: Colors.grey,
              pressElevation: 8.0,
              elevation: 2.0,
              selected: selectedOptions[option]!,
              tooltip: optionTooltips[option], // Tooltip for each chip
              onSelected: (bool selected) {
                setState(() {
                  selectedOptions[option] = selected;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void takeAction() {
    // Construct the command based on the selected toggles.
    List<String> selectedTransforms = [];
    if (selectedOptions['SUMMARY']!) selectedTransforms.add('explore_summary');
    if (selectedOptions['SKIM']!) selectedTransforms.add('explore_skim');
    if (selectedOptions['SPREAD']!) selectedTransforms.add('explore_spread');
    if (selectedOptions['CROSS TAB']!)
      selectedTransforms.add('explore_crosstab');

    // Execute the selected transformations using the R source function.
    for (var transform in selectedTransforms) {
      rSource(context, ref, transform);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Space above the beginning of the configs.
        configTopSpace,

        Row(
          children: [
            configLeftSpace,

            // The BUILD button.

            ActivityButton(
              pageControllerProvider:
                  summaryPageControllerProvider, // Optional navigation
              onPressed: () {
                takeAction();
              },
              child: const Text('Generate Dataset Summary'),
            ),

            configWidgetSpace,

            // The toggle buttons for the different options (SUMMARY, SKIM, SPREAD, CROSS TAB).
            summaryToggles(),
          ],
        ),
      ],
    );
  }
}
