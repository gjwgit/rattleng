/// Configuration for tree models.
//
// Time-stamp: <Thursday 2024-12-12 08:19:31 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
///
/// https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/complexity.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/loss_matrix.dart';
import 'package:rattle/providers/max_depth.dart';
import 'package:rattle/providers/min_bucket.dart';
import 'package:rattle/providers/min_split.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/priors.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/providers/tree_include_missing.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
import 'package:rattle/widgets/number_field.dart';

/// Descriptive tooltips for different decision tree algorithm types,
/// explaining the splitting method and potential biases.

Map decisionTreeTooltips = {
  AlgorithmType.conditional:
      'Uses statistical tests for unbiased splits, preventing overfitting.',
  AlgorithmType.traditional:
      'Uses greedy algorithms for splits, which may cause overfitting and bias.',
};

class TreeModelConfig extends ConsumerStatefulWidget {
  const TreeModelConfig({super.key});

  @override
  ConsumerState<TreeModelConfig> createState() => TreeModelConfigState();
}

class TreeModelConfigState extends ConsumerState<TreeModelConfig> {
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
                pageControllerProvider:
                    treePageControllerProvider, // Optional navigation

                onPressed: () async {
                  // TODO 20240926 gjw SPLIT THIS INTO OWN LOCAL FUNCTION

                  // Perform manual validation.

                  String? minSplitError =
                      validateInteger(_minSplitController.text, min: 0);
                  String? maxDepthError =
                      validateInteger(_maxDepthController.text, min: 1);
                  String? minBucketError =
                      validateInteger(_minBucketController.text, min: 1);
                  String? complexityError =
                      validateDecimal(_complexityController.text);
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
                          'Please ensure all input fields are valid before building '
                          'the decision tree:\n\n${errors.join('\n')}',
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

                    ref.read(lossMatrixProvider.notifier).state =
                        _lossMatrixController.text;

                    ref.read(treeAlgorithmProvider.notifier).state =
                        selectedAlgorithm;

                    // Run the R scripts.

                    String mt = 'model_template';
                    String mbc = 'model_build_ctree';
                    String mbr = 'model_build_rpart';
                    String etr = 'evaluate_template_tr';
                    String etu = 'evaluate_template_tu';
                    String erc = 'evaluate_riskchart';

                    if (selectedAlgorithm == AlgorithmType.conditional) {
                      await rSource(
                        context,
                        ref,
                        [mt, mbc, etr, erc, etu, erc],
                      );
                      ref.read(cTreeEvaluateProvider.notifier).state = true;
                    } else {
                      await rSource(
                        context,
                        ref,
                        [mt, mbr, etr, erc, etu, erc],
                      );
                      ref.read(rpartTreeEvaluateProvider.notifier).state = true;
                    }
                  }
                },
                child: const Text('Build Decision Tree'),
              ),
              configWidgetGap,
              Text('Target: ${getTarget(ref)}'),
              configWidgetGap,
              ChoiceChipTip<AlgorithmType>(
                options: AlgorithmType.values,
                getLabel: (AlgorithmType type) => type.displayName,
                selectedOption: selectedAlgorithm,
                tooltips: decisionTreeTooltips,
                onSelected: (AlgorithmType? selected) {
                  setState(() {
                    if (selected != null) {
                      selectedAlgorithm = selected;
                      ref.read(treeAlgorithmProvider.notifier).state = selected;
                    }
                  });
                },
              ),
              configWidgetGap,
              LabelledCheckbox(
                key: const Key('include_missing'),
                tooltip: '''

              Include missing values in decision tree splits to handle incomplete data without discarding observations.

              ''',
                label: 'Include Missing',
                provider: treeIncludeMissingProvider,
              ),
            ],
          ),
          configRowGap,
          // Min Split, Max Depth, and Min Bucket.
          Row(
            children: [
              NumberField(
                label: 'Min Split:',
                key: const Key('minSplitField'),
                controller: _minSplitController,
                tooltip: '''

                The minimum number of observations that must exist in a dataset
                at any node in order for a split of that node to be attempted.
                The default is 20.

                ''',
                inputFormatter:
                    FilteringTextInputFormatter.digitsOnly, // Integers only
                validator: (value) => validateInteger(value, min: 0),
                stateProvider: minSplitProvider,
              ),
              configWidgetGap,
              NumberField(
                label: 'Max Depth:',
                key: const Key('maxDepthField'),
                controller: _maxDepthController,
                tooltip: '''

                The maximum depth of any node of the final tree.  The root node
                is considered to be depth 0.  The maximum allowable depth for
                rpart() is 30.

                ''',
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (value) => validateInteger(value, min: 1, max: 30),
                max: 30,
                stateProvider: maxDepthProvider,
              ),
              configWidgetGap,
              NumberField(
                label: 'Min Bucket:',
                key: const Key('minBucketField'),
                controller: _minBucketController,
                tooltip: '''

                The minimum number of observations allowed in any leaf node of
                the decision tree.  The default value is one third of Min Split.

                ''',
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (value) => validateInteger(value, min: 1),
                stateProvider: minBucketProvider,
              ),
              configWidgetGap,
              NumberField(
                label: 'Complexity:',
                key: const Key('complexityField'),
                controller: _complexityController,
                tooltip: '''

                The complexity parameter is used to control the size of the
                decision tree and to select the optimal tree size.

                ''',
                enabled: selectedAlgorithm != AlgorithmType.conditional,
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
                ),
                validator: (value) => validateDecimal(value),
                stateProvider: complexityProvider,
                interval: 0.0005,
                decimalPlaces: 4,
              ),
              configWidgetGap,
              _buildTextField(
                label: 'Priors:',
                controller: _priorsController,
                key: const Key('priorsField'),
                textStyle: selectedAlgorithm == AlgorithmType.conditional
                    ? disabledTextStyle
                    : normalTextStyle,
                tooltip: '''

                Set the prior probabilities for each class.  E.g. for two
                classes: 0.5,0.5. Must add up to 1.

                ''',
                enabled: selectedAlgorithm != AlgorithmType.conditional,
                validator: (value) => _validatePriors(value),
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]+(,[0-9]+)*$'),
                ),
                maxWidth: 10,
              ),
              configWidgetGap,
              _buildTextField(
                label: 'Loss Matrix:',
                controller: _lossMatrixController,
                key: const Key('lossMatrixField'),
                textStyle: selectedAlgorithm == AlgorithmType.conditional
                    ? disabledTextStyle
                    : normalTextStyle,
                tooltip: '''

                Weight the outcome classes differently.  E.g., 0,10,1,0 (TN, FP,
                FN, TP).

                ''',
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

  // Validation logic for priors field. The priors field is specific to the TREE
  // config and so we define this here as a local util rather than in
  // `number_field.dart`

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

  // Validation logic for loss matrix field. The loss matrix field is specific
  // to the TREE config and so we define this here as a local util rather than
  // in `number_field.dart`

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

  // Create a text field.

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
      child: MarkdownTooltip(
        message: tooltip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // Set maximum width for the input field.
              width: maxWidth * 15.0,
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
                // Control enable state.
                enabled: enabled,
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
