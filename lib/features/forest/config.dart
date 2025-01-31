/// Widget to configure the FOREST tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2025-01-23 09:07:22 +1100 Graham Williams>
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/build_text_field.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/get_target_frequency.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
import 'package:rattle/widgets/number_field.dart';
import 'package:rattle/widgets/vector_number_field.dart';

/// Descriptive tooltips for different algorithm types,
/// explaining the splitting method and potential biases.

Map forestTooltips = {
  AlgorithmType.conditional: '''

      Build multiple decision trees using random samples of
      data and features, then aggregate their predictions.

      ''',
  AlgorithmType.traditional: '''

      Adjust for covariate distributions during tree construction
      to provide unbiased variable importance measures.

      ''',
};

/// The FOREST tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSouorce.

class ForestConfig extends ConsumerStatefulWidget {
  const ForestConfig({super.key});

  @override
  ConsumerState<ForestConfig> createState() => ForestConfigState();
}

class ForestConfigState extends ConsumerState<ForestConfig> {
  final TextEditingController _treesController = TextEditingController();
  final TextEditingController _variablesController = TextEditingController();
  final TextEditingController _treeNoController = TextEditingController();
  final TextEditingController _rfSampleSizeController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _treesController.dispose();
    _variablesController.dispose();
    _treeNoController.dispose();
    _rfSampleSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int treeNum = ref.watch(treeNumForestProvider);

    AlgorithmType selectedAlgorithm =
        ref.read(algorithmForestProvider.notifier).state;

    _rfSampleSizeController.text =
        ref.watch(forestSampleSizeProvider.notifier).state ?? '';

    /// Validates the sample size input for forest sampling.
    /// Returns null if valid, or an error message string if invalid.
    /// Sample size values must be positive integers not exceeding class frequencies.

    String? _validateSampleSize(String? value) {
      // Allow empty/null values.

      if (value == null || value.isEmpty) {
        return null;
      }

      // Get target class frequencies and parse input values.

      List<int> targetFreq = getTargetFrequency(ref);
      List<String> inputs = value.split(',').map((s) => s.trim()).toList();

      // Check number of input values doesn't exceed number of classes.

      if (inputs.length > targetFreq.length) {
        return 'Too many values. Maximum ${targetFreq.length} allowed';
      }

      // Validate each input value.

      for (int i = 0; i < inputs.length; i++) {
        // Check if value is a positive integer.

        if (!RegExp(r'^\d+$').hasMatch(inputs[i])) {
          return 'Only positive integers allowed';
        }

        int num = int.parse(inputs[i]);
        if (num < 1) {
          return 'Values must be greater than 0';
        }

        // Ensure sample size doesn't exceed class frequency.

        if (num > targetFreq[i]) {
          return 'Sample size $num at position ${i + 1} exceeds maximum class size ${targetFreq[i]}';
        }
      }

      return null;
    }

    /// Uses [_validateSampleSize] to check if [value] is valid.
    /// If valid (i.e., _validateSampleSize returns null) and [value] is not null,
    /// returns 'c($value)'. Otherwise, returns the validation error.

    String _formatSampleSize(String? value) {
      // If value matches the pattern c(...), return it directly.
      // - This check ensures we don't re-wrap an already wrapped value.

      if (value != null && RegExp(r'^c\(.*\)$').hasMatch(value)) {
        return value;
      }

      // Validate the value.

      final validationError = _validateSampleSize(value);

      // If there's a validation error, return that error.

      if (validationError != null) {
        return '';
      }

      // If the value is null or empty, there's no conversion to 'c(...)'.

      if (value == null || value.isEmpty) {
        return '';
      }

      // Otherwise, the value is valid and non-null, so convert it.

      return value;
    }

    return Column(
      spacing: configRowSpace,
      children: [
        // Space above the beginning of the configs.

        configBotGap,

        Row(
          spacing: configWidgetSpace,
          children: [
            // Space to the left of the configs.

            configLeftGap,

            // The BUILD button.

            ActivityButton(
              pageControllerProvider:
                  forestPageControllerProvider, // Optional navigation

              onPressed: () async {
                String? sampleSizeError =
                    _validateSampleSize(_rfSampleSizeController.text);

                // Collect all errors and the list may be added in future use.

                List<String> errors = [
                  if (sampleSizeError != null) 'Sample Size: $sampleSizeError',
                ];

                // Check if there are any errors.

                if (errors.isNotEmpty &&
                    selectedAlgorithm == AlgorithmType.traditional) {
                  // Show a warning dialog if validation fails.

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Validation Error'),
                      content: Text(
                        'Please ensure all input fields are valid before building '
                        'the random forest:\n\n${errors.join('\n')}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );

                  return;
                }

                // Run the R scripts.

                String mt = 'model_template';
                String mbrf = 'model_build_rforest';
                String mbcf = 'model_build_cforest';

                selectedAlgorithm == AlgorithmType.traditional
                    ? await rSource(
                        context,
                        ref,
                        [mt, mbrf],
                      )
                    : await rSource(
                        context,
                        ref,
                        [mt, mbcf],
                      );

                if (selectedAlgorithm == AlgorithmType.traditional) {
                  ref.read(randomForestEvaluateProvider.notifier).state = true;
                  ref.read(forestSampleSizeProvider.notifier).state =
                      _formatSampleSize(_rfSampleSizeController.text);
                } else if (selectedAlgorithm == AlgorithmType.conditional) {
                  ref.read(conditionalForestEvaluateProvider.notifier).state =
                      true;
                }

                // Update the state to make the forest evaluate tick box
                // automatically selected after the model build.

                ref.read(forestEvaluateProvider.notifier).state = true;

                await ref.read(forestPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build Random Forest'),
            ),

            Text('Target: ${getTarget(ref)}'),

            ChoiceChipTip<AlgorithmType>(
              options: AlgorithmType.values,
              getLabel: (AlgorithmType type) => type.displayName,
              selectedOption: selectedAlgorithm,
              tooltips: forestTooltips,
              onSelected: (AlgorithmType? selected) {
                setState(() {
                  if (selected != null) {
                    selectedAlgorithm = selected;
                    ref.read(algorithmForestProvider.notifier).state = selected;
                  }
                });
              },
            ),
          ],
        ),

        Row(
          spacing: configWidgetSpace,
          children: [
            // Space to the left of the configs.

            configLeftGap,

            NumberField(
              label: 'Trees:',
              key: const Key('treeForest'),
              controller: _treesController,
              tooltip: '''

                The ntree parameter specifies the number of trees to grow in the forest.

                ''',
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              validator: (value) => validateInteger(value, min: 10),
              stateProvider: treeNumForestProvider,
              interval: 10,
            ),

            NumberField(
              label: 'Variables:',
              key: const Key('variablesForest'),
              controller: _variablesController,
              tooltip: '''

                The mtry parameter defines the number of variables
                randomly selected as candidates at each split in the trees.

                ''',
              validator: validateVector,
              inputFormatter:
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
              stateProvider: predictorNumForestProvider,
            ),

            NumberField(
              label: 'NO. Tree:',
              key: const Key('treeNoForest'),
              controller: _treeNoController,
              tooltip: '''

                Which tree to display.

                ''',
              max: treeNum,
              validator: validateVector,
              inputFormatter:
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
              stateProvider: treeNoForestProvider,
            ),

            buildTextField(
              label: 'Sample Size:',
              controller: _rfSampleSizeController,
              key: const Key('rfSampleSizeField'),
              textStyle: selectedAlgorithm == AlgorithmType.conditional
                  ? disabledTextStyle
                  : normalTextStyle,
              tooltip: '''

                Specify a single sample size (e.g. 500), or a sample size 
                for each class (e.g., 500,500 for a binary model), 
                which may be useful in balancing class predictions

                ''',
              enabled: selectedAlgorithm != AlgorithmType.conditional,
              validator: (value) => _validateSampleSize(value),
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp('[0-9,]'),
              ),
              maxWidth: 10,
              ref: ref,
            ),

            LabelledCheckbox(
              key: const Key('imputeForest'),
              tooltip: '''

              Impute the median (numerical) or most frequent (categoric) value
              for missing data using na.roughfix() from randomForest.

              ''',
              label: 'Impute',
              provider: imputeForestProvider,
            ),
          ],
        ),
      ],
    );
  }
}
