/// Identify the models that the INTERACTIVE prediction popup will predict with.
///
/// Time-stamp: "Saturday 2026-08-15 10:12:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/tree.dart';
import 'package:rattle/utils/is_numeric_target.dart';

/// The `evaluate_model_*` scripts of the models ticked on the EVALUATE tab.
///
/// Each of those scripts sets the TEMPLATE variable `model` to the model it
/// describes and defines `pred_ra()` and `prob_ra()` for it, which is exactly
/// what `evaluate_interactive_predict.R` needs, so a script name is all the
/// popup has to know. The script also describes itself through `mdesc`, so the
/// labels come back from R with the predictions rather than being repeated
/// here.
///
/// A model appears only when its family is ticked AND that particular model has
/// been built, matching the pairing that `evaluateActivityButton` uses to
/// decide what to evaluate. The regression scripts are used for a numeric
/// target, where AdaBoost has no place as a classification-only algorithm.

List<String> interactiveModelScripts(WidgetRef ref) {
  final bool numeric = isNumericTarget(ref);

  // The family ticks, being the Model checkboxes along the top of the tab.

  final bool tree = ref.watch(treeEvaluateProvider);
  final bool forest = ref.watch(forestEvaluateProvider);
  final bool boost = ref.watch(boostEvaluateProvider);
  final bool neural = ref.watch(neuralEvaluateProvider);

  // The models that have actually been built. SVM and Linear have the one
  // provider serving as both the family tick and the built flag.

  final bool rpart = ref.watch(rpartTreeEvaluateProvider);
  final bool ctree = ref.watch(cTreeEvaluateProvider);
  final bool rforest = ref.watch(randomForestEvaluateProvider);
  final bool cforest = ref.watch(conditionalForestEvaluateProvider);
  final bool adaboost = ref.watch(adaBoostEvaluateProvider);
  final bool xgboost = ref.watch(xgBoostEvaluateProvider);
  final bool svm = ref.watch(svmEvaluateProvider);
  final bool linear = ref.watch(linearEvaluateProvider);
  final bool nnet = ref.watch(nnetEvaluateProvider);
  final bool neuralnet = ref.watch(neuralNetEvaluateProvider);

  final String suffix = numeric ? '_regression' : '';

  return <String>[
    if (tree && rpart) 'evaluate_model_rpart$suffix',
    if (tree && ctree) 'evaluate_model_ctree$suffix',
    if (forest && rforest) 'evaluate_model_rforest$suffix',
    if (forest && cforest) 'evaluate_model_cforest$suffix',

    // AdaBoost is classification only.

    if (boost && adaboost && !numeric) 'evaluate_model_adaboost',
    if (boost && xgboost) 'evaluate_model_xgboost$suffix',
    if (svm) 'evaluate_model_svm$suffix',

    // The linear model already predicts a number, so it has no separate
    // regression script.

    if (linear) 'evaluate_model_linear',
    if (neural && nnet) 'evaluate_model_nnet$suffix',
    if (neural && neuralnet) 'evaluate_model_neuralnet$suffix',
  ];
}
