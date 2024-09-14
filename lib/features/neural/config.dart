/// Widget to configure the NEURAL tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-09-10 05:55:42 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/max_nwts.dart';
import 'package:rattle/providers/nnet_hidden_neurons.dart';
import 'package:rattle/providers/nnet_maxit.dart';
import 'package:rattle/providers/nnet_skip.dart';
import 'package:rattle/providers/nnet_trace.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/number_field.dart';

/// The NEURAL tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class NeuralConfig extends ConsumerStatefulWidget {
  const NeuralConfig({super.key});

  @override
  ConsumerState<NeuralConfig> createState() => NeuralConfigState();
}

class NeuralConfigState extends ConsumerState<NeuralConfig> {
  // Controllers for the input fields.
  final TextEditingController _hiddenNeuronsController =
      TextEditingController();
  final TextEditingController _maxNWtsController = TextEditingController();
  final TextEditingController _maxitController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.
    _hiddenNeuronsController.dispose();
    _maxNWtsController.dispose();
    _maxitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Checkbox state.
    bool nnetTrace = ref.read(nnetTraceProvider.notifier).state;

    bool nnetSkip = ref.read(nnetSkipProvider.notifier).state;

    // Keep the value of text field.

    _hiddenNeuronsController.text =
        ref.read(hiddenNeuronsProvider.notifier).state.toString();
    _maxNWtsController.text =
        ref.read(maxNWtsProvider.notifier).state.toString();
    _maxitController.text = ref.read(maxitProvider.notifier).state.toString();

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
              onPressed: () async {
                // Perform manual validation.
                String? hiddenNeuronsError =
                    validateInteger(_hiddenNeuronsController.text, min: 1);
                String? maxNWtsError =
                    validateInteger(_maxNWtsController.text, min: 1);
                String? maxitError =
                    validateInteger(_maxitController.text, min: 1);

                // Collect all errors.
                List<String> errors = [
                  if (hiddenNeuronsError != null)
                    'Hidden Neurons: $hiddenNeuronsError',
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
                  ref.read(nnetTraceProvider.notifier).state = nnetTrace;
                  ref.read(nnetSkipProvider.notifier).state = nnetSkip;

                  ref.read(hiddenNeuronsProvider.notifier).state =
                      int.parse(_hiddenNeuronsController.text);
                  ref.read(maxNWtsProvider.notifier).state =
                      int.parse(_maxNWtsController.text);
                  ref.read(maxitProvider.notifier).state =
                      int.parse(_maxitController.text);

                  // Run the R scripts.
                  await rSource(context, ref, 'model_template');
                  await rSource(context, ref, 'model_build_neural_net');
                }
              },
              child: const Text('Build Neural Network'),
            ),

            configWidgetSpace,

            const Text(
              'Trace',
              style: normalTextStyle,
            ),
            Checkbox(
              key: const Key('NNET Trace'),
              value: nnetTrace,
              onChanged: (value) {
                setState(() {
                  nnetTrace = value!;
                  ref.read(nnetTraceProvider.notifier).state = value;
                });
              },
            ),

            configWidgetSpace,

            const Text(
              'Skip',
              style: normalTextStyle,
            ),
            Checkbox(
              value: nnetSkip,
              onChanged: (value) {
                setState(() {
                  nnetSkip = value!;
                  ref.read(nnetSkipProvider.notifier).state = value;
                });
              },
            ),
          ],
        ),
        configTopSpace,
        Row(
          children: [
            NumberField(
              label: 'Hidden Neurons:',
              key: const Key('hidden_neurons'),
              controller: _hiddenNeuronsController,

              tooltip: ''' Hidden neurons receive input from all the neurons 
 in the previous layer (input layer) and apply a weighted sum 
 of inputs, followed by an activation function.
              ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: hiddenNeuronsProvider,
            ),
            const SizedBox(width: 16),
            NumberField(
              label: 'Max NWts:',
              key: const Key('max_NWts'),
              controller: _maxNWtsController,

              tooltip: ''' The maxNWts parameter in the nnet function 
 controls the maximum number of weights allowed 
 in the neural network model.
              ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: maxNWtsProvider,
            ),
            const SizedBox(width: 16),
            NumberField(
              label: 'Maxit:',
              key: const Key('maxit'),
              controller: _maxitController,

              tooltip: ''' The maxit parameter in the nnet model 
 controls the maximum number of iterations (or epochs) 
 allowed during the training of the neural network.
              ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: maxitProvider,
            ),
          ],
        ),
      ],
    );
  }
}
