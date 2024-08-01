/// Widget to replicate a configuration UI for a tree model.
//
// Time-stamp: <Sunday 2024-06-09 06:10:08 +1000 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/widgets/activity_button.dart';

class TreeModelConfig extends ConsumerStatefulWidget {
  const TreeModelConfig({super.key});

  @override
  ConsumerState<TreeModelConfig> createState() => TreeModelConfigState();
}

class TreeModelConfigState extends ConsumerState<TreeModelConfig> {
  // Enum for algorithm types.
  AlgorithmType _selectedAlgorithm = AlgorithmType.traditional;

  // Controllers for the input fields.
  final TextEditingController _minSplitController =
      TextEditingController(text: '20');
  final TextEditingController _maxDepthController =
      TextEditingController(text: '20');
  final TextEditingController _minBucketController =
      TextEditingController(text: '7');
  final TextEditingController _complexityController =
      TextEditingController(text: '0.0100');
  final TextEditingController _priorsController = TextEditingController();
  final TextEditingController _lossMatrixController = TextEditingController();

  // Checkbox state.
  bool _includeMissing = false;

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
    const TextStyle smallTextStyle = TextStyle(fontSize: 12.0);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Algorithm Radio Buttons.
          Row(
            children: [
              ActivityButton(
                onPressed: () {

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
                    variable that we will model so that we can predict it's
                    value.

                    ''',
                    );
                  } else {
                    // Run the R scripts.

                    rSource(context, ref, 'model_template');
                    rSource(context, ref, 'model_build_rpart');
                  }
                  // TODO yyx 20240627 How should I restore this effect in the new Widget Pages?
                  // it failed to work only when user first click build on the panel because the pages are not yet updated.
                  // treePagesKey.currentState?.goToResultPage();
                },
                child: const Text('Build Decision Tree'),
              ),
              const SizedBox(width: 16),
              const Text(
                'Algorithm:',
                style: smallTextStyle,
              ),
              ...AlgorithmType.values.map((algorithmType) {
                return SizedBox(
                  width: 200,
                  child: RadioListTile<AlgorithmType>(
                    title: Text(
                      algorithmType.displayName,
                      style: smallTextStyle,
                    ),
                    value: algorithmType,
                    groupValue: _selectedAlgorithm,
                    onChanged: (value) {
                      setState(() {
                        _selectedAlgorithm = value!;
                      });
                    },
                  ),
                );
              }),

              const Text(
                'Include Missing',
                style: smallTextStyle,
              ),
              Checkbox(
                value: _includeMissing,
                onChanged: (value) {
                  setState(() {
                    _includeMissing = value!;
                  });
                },
              ),
              const SizedBox(width: 16),
              // Model Builder Title.
              const Text(
                'Model Builder: rpart',
                style: smallTextStyle,
              ),
            ],
          ),

          // Min Split and Max Depth.
          Row(
            children: [
              _buildNumberField(
                'Min Split:',
                _minSplitController,
                smallTextStyle,
              ),
              const SizedBox(width: 16),
              _buildNumberField(
                'Max Depth:',
                _maxDepthController,
                smallTextStyle,
              ),
              const SizedBox(width: 16),
              _buildNumberField(
                'Min Bucket:',
                _minBucketController,
                smallTextStyle,
              ),
            ],
          ),

          // Priors and Loss Matrix.
          Row(
            children: [
              _buildNumberField(
                'Complexity:',
                _complexityController,
                smallTextStyle,
              ),
              const SizedBox(width: 16),
              _buildTextField(
                'Priors:',
                _priorsController,
                smallTextStyle,
              ),
              const SizedBox(width: 16),
              _buildTextField(
                'Loss Matrix:',
                _lossMatrixController,
                smallTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to create a text field.
  Widget _buildTextField(
      String label, TextEditingController controller, TextStyle textStyle,) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textStyle),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            style: textStyle,
          ),
        ],
      ),
    );
  }

  // Helper method to create a number field.
  Widget _buildNumberField(
      String label, TextEditingController controller, TextStyle textStyle,) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textStyle),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

// Enum for algorithm types
enum AlgorithmType {
  traditional('Traditional'),
  conditional('Conditional');

  final String displayName;

  const AlgorithmType(this.displayName);
}
