/// Widget to configure the NEURAL tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-10-24 17:21:07 +1100 Graham Williams>
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
import 'package:rattle/providers/max_nwts.dart';
import 'package:rattle/providers/neural.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
import 'package:rattle/widgets/number_field.dart';
import 'package:rattle/widgets/vector_number_field.dart';

/// The NEURAL tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class NeuralConfig extends ConsumerStatefulWidget {
  const NeuralConfig({super.key});

  @override
  ConsumerState<NeuralConfig> createState() => NeuralConfigState();
}

class NeuralConfigState extends ConsumerState<NeuralConfig> {
  Map<String, String> neuralAlgorithm = {
    'nnet': '''
    
    A basic neural network with a single hidden layer.
    Suitable for simple tasks and small datasets.
    
    ''',
    'neuralnet': '''

    Supports multiple layers, ideal for complex patterns.
    Commonly used for deeper architectures.

    ''',
  };

  /// Function that is used for the calculation of the error.

  List<String> errorFunction = [
    'sse',
    'ce',
  ];

  /// Function that is used for smoothing the result of the cross product
  /// of the covariate or neurons and the weights.

  List<String> actionFunction = [
    'logistic',
    'tanh',
  ];

  // Controllers for the input fields.

  final TextEditingController _nnetSizeLayerController =
      TextEditingController();
  final TextEditingController _neuralHiddenController = TextEditingController();
  final TextEditingController _maxNWtsController = TextEditingController();
  final TextEditingController _thresholdController = TextEditingController();
  final TextEditingController _maxStepsController = TextEditingController();
  final TextEditingController _maxitController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.
    _nnetSizeLayerController.dispose();
    _maxNWtsController.dispose();
    _maxitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the value of text field.

    _nnetSizeLayerController.text =
        ref.read(hiddenLayerNeuralProvider.notifier).state.toString();
    _maxNWtsController.text =
        ref.read(maxNWtsProvider.notifier).state.toString();
    _maxitController.text =
        ref.read(maxitNeuralProvider.notifier).state.toString();

    String algorithm = ref.read(algorithmNeuralProvider.notifier).state;
    String function = ref.read(errorFctNeuralProvider.notifier).state;
    String action = ref.read(actionFctNeuralProvider.notifier).state;

    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 5),

        Row(
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.
            ActivityButton(
              key: const Key('Build Neural Network'),
              tooltip: '''

              Tap to build a Nerual Network model using the parameter values
              that you can set here.

              ''',
              pageControllerProvider:
                  neuralPageControllerProvider, // Optional navigation

              onPressed: () async {
                // Perform manual validation.
                String? sizeHiddenLayerError =
                    validateInteger(_nnetSizeLayerController.text, min: 1);
                String? maxNWtsError =
                    validateInteger(_maxNWtsController.text, min: 1);
                String? maxitError =
                    validateInteger(_maxitController.text, min: 1);

                // Collect all errors.
                List<String> errors = [
                  if (sizeHiddenLayerError != null)
                    'Size Hidden Layer: $sizeHiddenLayerError',
                  if (maxNWtsError != null) 'Max NWts: $maxNWtsError',
                  if (maxitError != null) 'Maxit: $maxitError',
                ];

                // Check if there are any errors.
                if (errors.isNotEmpty) {
                  // Show a warning dialog if validation fails.
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Validation Error'),
                      content: Text(
                        'Please ensure all input fields are valid before building the nnet model:\n\n${errors.join('\n')}',
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
                } else {
                  ref.read(hiddenLayerNeuralProvider.notifier).state =
                      int.parse(_nnetSizeLayerController.text);
                  ref.read(maxNWtsProvider.notifier).state =
                      int.parse(_maxNWtsController.text);
                  ref.read(maxitNeuralProvider.notifier).state =
                      int.parse(_maxitController.text);

                  // Run the R scripts.

                  await rSource(context, ref, ['model_template']);
                  if (context.mounted) {
                    if (algorithm == 'nnet') {
                      await rSource(context, ref, ['model_build_neural_nnet']);
                    } else if (algorithm == 'neuralnet') {
                      await rSource(
                        context,
                        ref,
                        ['model_build_neural_neuralnet'],
                      );
                    }
                  }
                }
              },
              child: const Text('Build Neural Network'),
            ),
            configWidgetSpace,

            const Text(
              'Algorithm:',
              style: normalTextStyle,
            ),

            configWidgetSpace,

            ChoiceChipTip<String>(
              options: neuralAlgorithm.keys.toList(),
              selectedOption: algorithm,
              tooltips: neuralAlgorithm,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    algorithm = chosen;
                    ref.read(algorithmNeuralProvider.notifier).state = chosen;
                  }
                });
              },
            ),

            configWidgetSpace,

            LabelledCheckbox(
              key: const Key('NNET Trace'),
              tooltip: '''

              Enable tracing optimization for the **single layer neural
              network**. The prediction error is provided after every 10 training
              iterations in the Console.

              ''',
              label: 'Trace',
              provider: traceNeuralProvider,
              enabled: algorithm == 'nnet',
            ),

            configWidgetSpace,

            LabelledCheckbox(
              tooltip: '''

              Add skip-layer connections from input to output for the **single
              layer neural network**.

              ''',
              label: 'Skip',
              provider: skipNeuralProvider,
              enabled: algorithm == 'nnet',
            ),
            configWidgetSpace,
            LabelledCheckbox(
              key: const Key('Neural Ignore Categoric'),
              tooltip: '''

              Build the model ignoring the categoric variables.

              ''',
              label: 'Ignore Categoric',
              provider: ignoreCategoricNeuralProvider,
            ),
            configWidgetSpace,
            Text('Target: ${getTarget(ref)}'),
          ],
        ),

        configRowSpace,

        Row(
          children: [
            algorithm == 'nnet'
                ? NumberField(
                    label: 'Hidden Layer:',
                    key: const Key('hidden_layers'),
                    controller: _nnetSizeLayerController,

                    tooltip: '''

                    The Hidden Layer parameter is used as the size parameter in
                    the nnet() model which specifies the number of units
                    (neurons) in the single hidden layer of the neural
                    network. It is a simple integer.
              
                    ''',
                    inputFormatter:
                        FilteringTextInputFormatter.digitsOnly, // Integers only
                    validator: (value) => validateInteger(value, min: 1),
                    stateProvider: hiddenLayerNeuralProvider,
                  )
                : VectorNumberField(
                    controller: _neuralHiddenController,
                    stateProvider: hiddenLayersNeuralProvider,
                    label: 'Hidden Layers',
                    tooltip: '''

                    The Hidden Layers parameter is a vector of comma separated
                    integers specifying the number of hidden neurons (vertices)
                    in each of the layers. The number of layers is the number of
                    integers supplied. For example, to specify a network
                    architecture with 10 neurons in the first layer, 5 int he
                    next, and 2 in the penultimate layer, we specify "10,5,2".

                    ''',
                    validator: validateVector,
                    inputFormatter:
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
                  ),
            configWidgetSpace,
            NumberField(
              label: 'Max Iterations:',
              key: const Key('maxit'),
              controller: _maxitController,
              enabled: algorithm == 'nnet',

              tooltip: '''

              The maximum number of iterations (or epochs) allowed during the
              training of the neural network.

              ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: maxitNeuralProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Max Weights:',
              key: const Key('max_nwts'),
              controller: _maxNWtsController,
              enabled: algorithm == 'nnet',

              tooltip: '''

              The maximum number of weights allowed in the neural network model.
              
              ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: maxNWtsProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Threshold:',
              key: const Key('thresholdNeuralField'),
              controller: _thresholdController,
              tooltip: '''

                The numeric value specifying the threshold for the partial 
                derivatives of the error function as stopping criteria.

                ''',
              enabled: algorithm != 'nnet',
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              validator: (value) => validateDecimal(value),
              stateProvider: thresholdNeuralProvider,
              interval: 0.0005,
              decimalPlaces: 4,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Max Steps:',
              key: const Key('neuralMaxStepField'),
              controller: _maxStepsController,
              tooltip: '''

                The maximum steps for the training of the neural network. 
                Reaching this maximum leads to a stop of the neural network's training process.

                ''',
              enabled: algorithm != 'nnet',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(value, min: 1000),
              stateProvider: stepMaxNeuralProvider,
            ),
          ],
        ),
        configRowSpace,
        Row(
          children: [
            variableChooser(
              'Error Function',
              errorFunction,
              function,
              ref,
              errorFctNeuralProvider,
              tooltip: '''

              Function that is used for the calculation of the error. 
              Alternatively, the strings 'sse' and 'ce' which stand for 
              the sum of squared errors and the cross-entropy can be used.

              ''',
              enabled: algorithm == 'neuralnet',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(errorFctNeuralProvider.notifier).state = value;
                }
              },
            ),
            configWidgetSpace,
            variableChooser(
              'Action Function',
              actionFunction,
              action,
              ref,
              actionFctNeuralProvider,
              tooltip: '''

              Function that is used for smoothing the result of the cross product 
              of the covariate or neurons and the weights. Additionally the strings,
              'logistic' and 'tanh' are possible for the logistic function and 
              tangent hyperbolicus.

              ''',
              enabled: algorithm == 'neuralnet',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(actionFctNeuralProvider.notifier).state = value;
                }
              },
            ),
          ],
        ),
        configBotSpace,
      ],
    );
  }
}
