/// A provider for the parameters for evaluate.
///
/// Time-stamp: <Friday 2025-01-17 13:54:49 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/settings.dart';

final adaBoostEvaluateProvider = StateProvider<bool>((ref) => false);
final boostEvaluateProvider = StateProvider<bool>((ref) => false);
final conditionalForestEvaluateProvider = StateProvider<bool>((ref) => false);
final cTreeEvaluateProvider = StateProvider<bool>((ref) => false);

// 20250117 zy Using `ref.watch` ensures that this provider automatically
// rebuilds whenever the watched provider (`useValidationSettingProvider`)
// changes. 20250117 gjw Docs suggest using a watch() over a read() in
// general. In this way when useValidation changes then the default datasetType
// is set back to Validation/Tuning as the default irrespective of where it was
// previously. This then also captures the fact that useValidation seems to be
// set on startup after datasetType is set. With a read() instead of watch() the
// default value of datasetType remains unset on startup and so no default is
// seen in the UI (unless we change useValidation in SETTINGS). In short,
// watch() seems to work

final datasetTypeProvider = StateProvider<String>(
  (ref) => ref.watch(useValidationSettingProvider) ? 'Validation' : 'Tuning',
);

final forestEvaluateProvider = StateProvider<bool>((ref) => false);
final hClusterEvaluateProvider = StateProvider<bool>((ref) => false);
final kMeansEvaluateProvider = StateProvider<bool>((ref) => false);
final linearEvaluateProvider = StateProvider<bool>((ref) => false);
final neuralEvaluateProvider = StateProvider<bool>((ref) => false);
final nnetEvaluateProvider = StateProvider<bool>((ref) => false);
final neuralNetEvaluateProvider = StateProvider<bool>((ref) => false);
final svmEvaluateProvider = StateProvider<bool>((ref) => false);
final randomForestEvaluateProvider = StateProvider<bool>((ref) => false);
final rpartTreeEvaluateProvider = StateProvider<bool>((ref) => false);
final treeEvaluateProvider = StateProvider<bool>((ref) => false);
final xgBoostEvaluateProvider = StateProvider<bool>((ref) => false);

// List of all the providers of model to be evaluated.

final List<StateProvider> evaluateProviders = [
  adaBoostEvaluateProvider,
  boostEvaluateProvider,
  conditionalForestEvaluateProvider,
  cTreeEvaluateProvider,
  datasetTypeProvider,
  forestEvaluateProvider,
  hClusterEvaluateProvider,
  kMeansEvaluateProvider,
  linearEvaluateProvider,
  neuralEvaluateProvider,
  nnetEvaluateProvider,
  neuralNetEvaluateProvider,
  svmEvaluateProvider,
  randomForestEvaluateProvider,
  rpartTreeEvaluateProvider,
  treeEvaluateProvider,
  xgBoostEvaluateProvider,
];
