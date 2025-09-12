/// Map neural feature template patterns to their values.
///
// Time-stamp: "Friday 2025-09-12 14:12:17 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/neural.dart';

/// Map neural template patterns in [code] to their current values.

String mapNeural(WidgetRef ref, String code) {
  // Obtain the current values of the global variables.

  int hiddenLayerSizes = ref.read(hiddenLayerNeuralProvider);
  int neuralStepMax = ref.read(stepMaxNeuralProvider);
  int nnetMaxit = ref.read(maxitNeuralProvider);

  bool neuralIgnoreCategoric = ref.read(ignoreCategoricNeuralProvider);

  double neuralThreshold = ref.read(thresholdNeuralProvider);

  String hiddenNeurons = ref.read(hiddenLayersNeuralProvider);
  String neuralActivationFct = ref.read(activationFctNeuralProvider);
  String neuralErrorFct = ref.read(errorFctNeuralProvider);

  // Perform the mapping.

  code = code.replaceAll('<NNET_HIDDEN_LAYERS>', hiddenLayerSizes.toString());

  code = code.replaceAll('<NEURAL_HIDDEN_LAYERS>', 'c($hiddenNeurons)');
  code = code.replaceAll('<NEURAL_MAXIT>', nnetMaxit.toString());
  code = code.replaceAll(
    '<NEURAL_MAX_NWTS>',
    ref.read(neuralMaxWeightsProvider).toString(),
  );
  code = code.replaceAll(
    '<NEURAL_ERROR_FCT>',
    '"${neuralErrorFct.toString()}"',
  );
  code = code.replaceAll(
    '<NEURAL_ACT_FCT>',
    '"${neuralActivationFct.toString()}"',
  );
  if (neuralActivationFct != 'relu') {
    code = code.replaceAll(
      '<NEURAL_ACT_FCT>',
      '"${neuralActivationFct.toString()}"',
    );
  } else if (neuralActivationFct == 'relu') {
    // relu corresponds to the ReLU function from the sigmoid package in R.

    code = code.replaceAll('<NEURAL_ACT_FCT>', 'relu');
  }

  code = code.replaceAll('<NEURAL_THRESHOLD>', neuralThreshold.toString());
  code = code.replaceAll('<NEURAL_STEP_MAX>', neuralStepMax.toString());

  code = code.replaceAll(
    '<NEURAL_IGNORE_CATEGORIC>',
    neuralIgnoreCategoric.toString().toUpperCase(),
  );

  return (code);
}
