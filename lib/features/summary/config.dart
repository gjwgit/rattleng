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
    'GLIMPSE', // Added GLIMPSE
  ];

  Map<String, bool> selectedOptions = {
    'SUMMARY': true,
    'SKIM': false,
    'SPREAD': false,
    'CROSS TAB': false,
    'GLIMPSE': false, // Default to false.
  };

  // Tooltips for each option
  Map<String, String> optionTooltips = {
    'SUMMARY': 'Generate the summary of the dataset.',
    'SKIM': 'Perform a skim summary for an overview of variables.',
    'SPREAD': 'Spread categorical variables.',
    'CROSS TAB': 'Generate a cross-tabulation (can be expensive).',
    'GLIMPSE':
        'Quickly glance at a few rows of the dataset.', // Tooltip for GLIMPSE
  };

  // Modify selection logic to only allow one option at a time
  void selectOnlyOneOption(String selectedOption) {
    setState(() {
      selectedOptions.updateAll((key, value) => false); // Deselect all options
      selectedOptions[selectedOption] = true; // Select the current option
    });
  }

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
                selectOnlyOneOption(option); // Only select one option at a time
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void takeAction() {
    // Construct the command based on the selected toggle.
    String selectedTransform = '';

    rSource(context, ref, "explore_summary");

    if (selectedOptions['SUMMARY']!) {
      selectedTransform = 'explore_summary';
      // Navigate to page 1 when SUMMARY is selected
      final pageController = ref.read(summaryPageControllerProvider);
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedOptions['GLIMPSE']!) {
      selectedTransform = 'explore_glimpse';
      // Navigate to page 2 when GLIMPSE is selected
      final pageController = ref.read(summaryPageControllerProvider);
      pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedOptions['SKIM']!) {
      selectedTransform = 'explore_skim';
      // Navigate to page 3 when SKIM is selected
      final pageController = ref.read(summaryPageControllerProvider);
      pageController.animateToPage(
        3,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedOptions['SPREAD']!) {
      selectedTransform = 'explore_spread';
      // Navigate to page 4 when SPREAD is selected
      final pageController = ref.read(summaryPageControllerProvider);
      pageController.animateToPage(
        4,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedOptions['CROSS TAB']!) {
      selectedTransform = 'explore_cross_tab';
      // Navigate to page 5 when CROSS TAB is selected
      final pageController = ref.read(summaryPageControllerProvider);
      pageController.animateToPage(
        5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Execute the selected transformation using the R source function.
    if (selectedTransform.isNotEmpty) {}
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

            // The toggle buttons for the different options (SUMMARY, SKIM, SPREAD, CROSS TAB, GLIMPSE).
            summaryToggles(),
          ],
        ),
      ],
    );
  }
}
