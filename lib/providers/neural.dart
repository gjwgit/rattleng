/// Providers for NEURAL feature NNET and NEURALNET options.
///
/// Time-stamp: <Sunday 2025-02-02 19:28:53 +1100 Graham Williams>
///
/// Copyright (C) 2024, Togaware Pty Ltd.
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
/// Authors: Zheyuan Xu, Graham Williams

library;

// TODO 20241029 gjw EVENTUALLY RENAME THESE TO START WITH `neural`.

import 'package:flutter_riverpod/flutter_riverpod.dart';

final activationFctNeuralProvider = StateProvider<String>((ref) => 'logistic');

// 20250202 gjw For now neuralnet is not fully operational for our typical
// classification tasks. Stay with just nnet for now.

final algorithmNeuralProvider = StateProvider<String>((ref) => 'nnet');

final errorFctNeuralProvider = StateProvider<String>((ref) => 'sse');
final hiddenLayersNeuralProvider = StateProvider<String>((ref) => '10');
final ignoreCategoricNeuralProvider = StateProvider<bool>((ref) => true);
final maxitNeuralProvider = StateProvider<int>((ref) => 100);
final hiddenLayerNeuralProvider = StateProvider<int>((ref) => 10);

// 20250131 gjw RattleV5 uses 10,000 as the default so do the same here.

final neuralMaxWeightsProvider = StateProvider<int>((ref) => 10000);

// 20250131 gjw Set the SKIP to true since that's the default in RattleV5.

final neuralSkipProvider = StateProvider<bool>((ref) => true);
final stepMaxNeuralProvider = StateProvider<int>((ref) => 10000);
final thresholdNeuralProvider = StateProvider<double>((ref) => 0.0100);
final traceNeuralProvider = StateProvider<bool>((ref) => false);
