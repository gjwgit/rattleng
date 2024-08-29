/// Widget to replicate a configuration UI for a tree model.
//
// Time-stamp: <Thursday 2024-08-29 20:45:20 +1000 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-07-21 17:08:42 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/complexity.dart';
import 'package:rattle/providers/loss_matrix.dart';
import 'package:rattle/providers/max_depth.dart';
import 'package:rattle/providers/min_bucket.dart';
import 'package:rattle/providers/min_split.dart';
import 'package:rattle/providers/priors.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/providers/tree_include_missing.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/number_field.dart';

class TreeModelConfig extends ConsumerStatefulWidget {
  const TreeModelConfig({super.key});

  @override
  ConsumerState<TreeModelConfig> createState() => TreeModelConfigState();
}

class TreeModelConfigState extends ConsumerState<TreeModelConfig> {
  // Enum for algorithm types.

  // Controllers for the input fields.
  final TextEditingController _minSplitController = TextEditingController();
  final TextEditingController _maxDepthController = TextEditingController();
  final TextEditingController _minBucketController = TextEditingController();
  final TextEditingController _complexityController = TextEditingController();
  final TextEditingController _priorsController = TextEditingController();
  final TextEditingController _lossMatrixController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.
    _minSplitController.dispose();
    _maxDepthController.dispose();
    _minBucketController.dispose();
    _complexityController.dispose();
    _priorsController.dispose();
    _lossMatrixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define a smaller text style.
    const TextStyle normalTextStyle = TextStyle(fontSize: 14.0);

    // Define a text style for disabled fields.
    const TextStyle disabledTextStyle = TextStyle(
      fontSize: 14.0,
      color: Colors.grey, // Grey out the text
    );

    // Keep the value of text field.

    _minSplitController.text =
        ref.read(minSplitProvider.notifier).state.toString();
    _maxDepthController.text =
        ref.read(maxDepthProvider.notifier).state.toString();
    _minBucketController.text =
        ref.read(minBucketProvider.notifier).state.toString();
    _complexityController.text =
        ref.read(complexityProvider.notifier).state.toString();
    _priorsController.text = ref.read(priorsProvider.notifier).state.toString();
    _lossMatrixController.text =
        ref.read(lossMatrixProvider.notifier).state.toString();

    AlgorithmType selectedAlgorithm =
        ref.read(treeAlgorithmProvider.notifier).state;

    // Checkbox state.
    bool includeMissing = ref.read(treeIncludeMissingProvider.notifier).state;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Algorithm Radio Buttons.
          Row(
            children: [
              ActivityButton(
                key: const Key('Build Decision Tree'),
                onPressed: () {
                  // Perform manual validation.
                  String? minSplitError =
                      validateInteger(_minSplitController.text, min: 0);
                  String? maxDepthError =
                      validateInteger(_maxDepthController.text, min: 1);
                  String? minBucketError =
                      validateInteger(_minBucketController.text, min: 1);
                  String? complexityError =
                      _validateComplexity(_complexityController.text);
                  String? priorsError = _validatePriors(_priorsController.text);
                  String? lossMatrixError =
                      _validateLossMatrix(_lossMatrixController.text);

                  // Collect all errors.
                  List<String> errors = [
                    if (minSplitError != null) 'Min Split: $minSplitError',
                    if (maxDepthError != null) 'Max Depth: $maxDepthError',
                    if (minBucketError != null) 'Min Bucket: $minBucketError',
                    if (complexityError != null) 'Complexity: $complexityError',
                    if (priorsError != null) 'Priors: $priorsError',
                    if (lossMatrixError != null)
                      'Loss Matrix: $lossMatrixError',
                  ];

                  // Check if there are any errors.
                  if (errors.isNotEmpty) {
                    // Show a warning dialog if validation fails.
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Validation Error'),
                        content: Text(
                          'Please ensure all input fields are valid before building the decision tree:\n\n${errors.join('\n')}',
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
                  // Require a target variable.
                  if (getTarget(ref) == 'NULL') {
                    showOk(
                      context: context,
                      title: 'No Target Specified',
                      content: '''

                    Please choose a variable from amongst those variables in the
                    dataset as the **Target** for the model. You can do this
                    from the **Dataset** tab's **Roles** feature. When building
                    a predictive model, like a decision tree, we need a target
                    variable that we will model so that we can predict its
                    value.

                    ''',
                    );
                  } else {
                    // Update provider value.

                    ref.read(minSplitProvider.notifier).state =
                        int.parse(_minSplitController.text);
                    ref.read(maxDepthProvider.notifier).state =
                        int.parse(_maxDepthController.text);
                    ref.read(minBucketProvider.notifier).state =
                        int.parse(_minBucketController.text);

                    ref.read(complexityProvider.notifier).state =
                        double.parse(_complexityController.text);

                    ref.read(priorsProvider.notifier).state =
                        _priorsController.text;

                    ref.read(treeIncludeMissingProvider.notifier).state =
                        includeMissing;
                    ref.read(lossMatrixProvider.notifier).state =
                        _lossMatrixController.text;

                    ref.read(treeAlgorithmProvider.notifier).state =
                        selectedAlgorithm;

                    // Run the R scripts.
                    rSource(context, ref, 'model_template');
                    if (selectedAlgorithm == AlgorithmType.conditional) {
                      rSource(context, ref, 'model_build_ctree');
                    } else {
                      rSource(context, ref, 'model_build_rpart');
                    }
                  }
                  // TODO yyx 20240627 How should I restore this effect in the new Widget Pages?
                  // it failed to work only when the user first clicks build on the panel because the pages are not yet updated.
                  // treePagesKey.currentState?.goToResultPage();
                },
                child: const Text('Build Decision Tree'),
              ),
              const SizedBox(width: 16),
              const Text(
                'Algorithm:',
                style: normalTextStyle,
              ),
              configLeftSpace,

              ChoiceChipTip<AlgorithmType>(
                options: AlgorithmType.values,
                getLabel: (AlgorithmType type) => type.displayName,
                selectedOption: selectedAlgorithm,
                onSelected: (AlgorithmType? selected) {
                  setState(() {
                    if (selected != null) {
                      selectedAlgorithm = selected;
                      ref.read(treeAlgorithmProvider.notifier).state = selected;
                    }
                  });
                },
              ),
              configLeftSpace,

              const Text(
                'Include Missing',
                style: normalTextStyle,
              ),
              Checkbox(
                value: includeMissing,
                onChanged: (value) {
                  setState(() {
                    includeMissing = value!;
                    ref.read(treeIncludeMissingProvider.notifier).state = value;
                  });
                },
              ),
              const SizedBox(width: 16),
              // Model Builder Title.
              Text(
                selectedAlgorithm == AlgorithmType.traditional
                    ? 'Model Builder: rpart'
                    : 'Model Builder: ctree',
                style: normalTextStyle,
              ),
            ],
          ),
          configTopSpace,
          // Min Split, Max Depth, and Min Bucket.
          Row(
            children: [
              NumberField(
                label: 'Min Split:',
                key: const Key('minSplitField'),
                controller: _minSplitController,

                tooltip: ''' This is the minimum number of observations
 that must exist in a dataset at any node in
 order for a split of that node to be attempted. 
 The default is 20.''',
                inputFormatter:
                    FilteringTextInputFormatter.digitsOnly, // Integers only
                validator: (value) => validateInteger(value, min: 0),
                stateProvider: minSplitProvider,
              ),
              const SizedBox(width: 16),
              NumberField(
                label: 'Max Depth:',
                key: const Key('maxDepthField'),
                controller: _maxDepthController,
                tooltip:
                    ''' This is the maximum depth of any node of the final tree. 
 The root node is considered to be depth 0. 
 Note that a depth beyond 30 will give nonsense
 results on 32-bit machines. The default is 30.''',
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (value) => validateInteger(value, min: 1),
                stateProvider: maxDepthProvider,
              ),
              const SizedBox(width: 16),
              NumberField(
                label: 'Min Bucket:',
                key: const Key('minBucketField'),
                controller: _minBucketController,
                tooltip: ''' This is the minimum number of observations 
 allowed in any leaf node of the decision tree. 
 The default value is one third of the Min Split.''',
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (value) => validateInteger(value, min: 1),
                stateProvider: minBucketProvider,
              ),
              const SizedBox(width: 16),
              NumberField(
                label: 'Complexity:',
                key: const Key('complexityField'),
                controller: _complexityController,
                tooltip:
                    ''' The complexity parameter is used to control the size 
 of the decision tree and to select the optimal tree size.''',
                enabled: selectedAlgorithm != AlgorithmType.conditional,
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
                ),
                validator: (value) => _validateComplexity(value),
                stateProvider: complexityProvider,
                interval: 0.0005,
                decimalPlaces: 4,
              ),
              const SizedBox(width: 16),
              _buildTextField(
                label: 'Priors:',
                controller: _priorsController,
                key: const Key('priorsField'),
                textStyle: selectedAlgorithm == AlgorithmType.conditional
                    ? disabledTextStyle
                    : normalTextStyle,
                tooltip: ''' Set the prior probabilities for each class. 
 E.g. for two classes: 0.5,0.5. Must add up to 1.''',
                enabled: selectedAlgorithm != AlgorithmType.conditional,
                validator: (value) => _validatePriors(value),
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]+(,[0-9]+)*$'),
                ),
                maxWidth: 10,
              ),
              const SizedBox(width: 16),
              _buildTextField(
                label: 'Loss Matrix:',
                controller: _lossMatrixController,
                key: const Key('lossMatrixField'),
                textStyle: selectedAlgorithm == AlgorithmType.conditional
                    ? disabledTextStyle
                    : normalTextStyle,
                tooltip: ''' Weight the outcome classes differently. 
 E.g., 0,10,1,0 (TN, FP, FN, TP).''',
                enabled: selectedAlgorithm != AlgorithmType.conditional,
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]+(,[0-9]+)*$'),
                ),
                validator: (value) => _validateLossMatrix(value),
                maxWidth: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Validation logic for complexity field.
  String? _validateComplexity(String? value) {
    if (value == null || value.isEmpty) return 'Cannot be empty';
    double? doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue < 0.0000 || doubleValue > 1.0000) {
      return 'Must be between 0.0000 and 1.0000';
    }

    return null;
  }

  // Validation logic for priors field.
  String? _validatePriors(String? value) {
    if (value != null && value.isNotEmpty) {
      List<String> parts = value.split(',');

      double sum = 0.0;
      for (var part in parts) {
        double? num = double.tryParse(part.trim());
        if (num == null) return 'Each part must be a number';
        sum += num;
      }
      if (sum != 1.0) return 'The sum must equal 1.0';
    }

    return null;
  }

  // Validation logic for loss matrix field.
  String? _validateLossMatrix(String? value) {
    if (value != null && value.isNotEmpty) {
      List<String> parts = value.split(',');
      if (parts.length != 4) {
        return 'Must contain four comma-separated integers';
      }

      for (var part in parts) {
        if (int.tryParse(part.trim()) == null) {
          return 'Each part must be an integer';
        }
      }
      // Check if the first and last elements are zero (for diagonal zeros).
      if (parts.first.trim() != '0' || parts[3].trim() != '0') {
        return 'Loss matrix must have zeros on diagonals (first and last elements)';
      }
    }

    return null;
  }

  // Helper method to create a text field.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextStyle textStyle,
    required String tooltip,
    required bool enabled,
    required String? Function(String?) validator,
    required TextInputFormatter inputFormatter,
    required int maxWidth,
    required Key key,
  }) {
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: maxWidth * 15.0, // Set maximum width for the input field
              child: TextFormField(
                key: key,
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: const UnderlineInputBorder(),
                  errorText: validator(controller.text),
                  errorStyle: const TextStyle(fontSize: 10),
                ),
                style: textStyle,
                enabled: enabled, // Control enable state
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
