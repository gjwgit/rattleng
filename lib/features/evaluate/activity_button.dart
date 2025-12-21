/// Activity Button to run appropriate evaluation.
///
/// Copyright (C) 2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Friday 2025-09-12 16:53:51 +1000 Graham Williams"
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

import 'package:flutter/material.dart';

import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/tree.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_risk.dart';
import 'package:rattle/utils/is_numeric_target.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/widgets/activity_button.dart';

/// Executes model evaluation based on the given parameters and conditions.
///
/// [executed] - Boolean indicating if the model evaluation should proceed.
/// [parameters] - List of parameters specific to the model.
/// [datasetSplitType] - String indicating the dataset split type ('Training', 'Tuning', etc.).
/// [context] - Build context for the operation.
/// [ref] - Reference used in the evaluation (e.g., for dependency injection).

Future<void> executeEvaluation({
  required bool executed,
  required List parameters,
  required String datasetSplitType,
  required BuildContext context,
  required dynamic ref,
}) async {
  // 20250805 gjw On removing `hand` from the list of scripts to run, due to
  // `hmeasure` being removed from CRAN, [hd] below has become the empty
  // string, for convenience, expecting the `hmeasure` package to resurface in
  // CRAN, and so keeping [hd] in all the places where it needs to be. So
  // check here and remove any empty strings in the list [parameters].

  parameters.removeWhere((s) => s.isEmpty);

  // 20241220 gjw One of the following templates then needs to be
  // run to convert the appropriate predictions and probabilities
  // to the variables that are non-specific to a dataset
  // partition.

  final templateMap = {
    'Training': 'evaluate_template_tr',
    'Tuning': 'evaluate_template_tu',
    'Validation': 'evaluate_template_tu',
    'Testing': 'evaluate_template_te',
    'Complete': 'evaluate_template_tc',
  };

  if (executed) {
    final template = templateMap[datasetSplitType] ??
        (throw Exception('Invalid datasetSplitType: $datasetSplitType'));

    // Insert 'template' as the second item in the parameters list.

    final selectedParameters = [
      parameters.first,
      template,
      ...parameters.skip(1),
    ];

    await rSource(context, ref, selectedParameters.cast<String>());

    // Add a delay to avoid overrunning the CONSOLE which reuslts in scripts
    // being truncated withthe current R CONSOLE implementation. This works
    // for me on my kadesh Ubuntu laptop. It may be less of a problem on
    // slower machines. (gjw 20250316)

    await Future.delayed(Duration(milliseconds: 500));
  }
}

Widget evaluateActivityButton(BuildContext context, dynamic ref) {
  // Current evaluations are focused on classification rather than regression.
  // Evaluate is disabled when target variable is numeric.

  bool numericDisabled = isNumericTarget(ref);

  return ActivityButton(
    pageControllerProvider: evaluatePageControllerProvider,
    onPressed: () async {
      if (numericDisabled) {
        showOk(
          context: context,
          title: 'Numeric Target Variable',
          content: '''

          Rattle's current evaluations are focused on classification
          models rather than regression models.  Model evaluation is
          presently disabled when the target variable is numeric as it
          is currently.

          To explore the evaluations please select a categoric target
          variable.

          ''',
        );
      } else {
        // Retrieve the boolean state indicating if the evaluation was executed.

        bool adaBoostExecuted = ref.watch(adaBoostEvaluateProvider);
        bool boostTicked = ref.watch(boostEvaluateProvider);
        bool conditionalForestExecuted = ref.watch(
          conditionalForestEvaluateProvider,
        );
        bool ctreeExecuted = ref.watch(cTreeEvaluateProvider);
        bool forestTicked = ref.watch(forestEvaluateProvider);
        bool linearExecuted = ref.watch(linearEvaluateProvider);
        bool nnetExecuted = ref.watch(nnetEvaluateProvider);
        bool neuralNetExecuted = ref.watch(neuralNetEvaluateProvider);
        bool neuralTicked = ref.watch(neuralEvaluateProvider);
        bool randomForestExecuted = ref.watch(
          randomForestEvaluateProvider,
        );
        bool rpartExecuted = ref.watch(rpartTreeEvaluateProvider);
        bool svmExecuted = ref.watch(svmEvaluateProvider);
        bool treeExecuted = ref.watch(treeEvaluateProvider);
        bool xgBoostExecuted = ref.watch(xgBoostEvaluateProvider);

        String datasetSplitType = ref.watch(datasetTypeProvider);

        // [datasetRisk] can be 'NULL' if the risk variable is not set.

        String datasetRisk = getRisk(ref);

        // 20241220 gjw Identify constants corresponding to the various
        // evaluation commands for each model to generate the required
        // TEMPLATE variables. This is being updated to use the TEMPLATE
        // variables one model at a time. Those that have _model_ are
        // updated.

        String ea = 'evaluate_model_adaboost';
        String ec = 'evaluate_model_ctree';
        String el = 'evaluate_model_linear';
        String en = 'evaluate_model_nnet';
        String er = 'evaluate_model_rpart';
        String es = 'evaluate_model_svm';
        String ex = 'evaluate_model_xgboost';
        String ent = 'evaluate_model_neuralnet';

        String ecf = 'evaluate_model_cforest';
        String erf = 'evaluate_model_rforest';

        // 20241220 gjw Finally we will run the generic templates for
        // the various performance measures.

        String em = 'evaluate_measure_error_matrix';
        String ro = 'evaluate_measure_roc';
        String erc = 'evaluate_measure_riskchart';
        String ero = 'evaluate_measure_rocr';

        // 20250805 gjw The hmeasure package was removed from CRAN
        // 20250802.  String hd = 'evaluate_measure_hand';

        String hd = '';

        // Execute evaluation for rpart model if it was executed and
        // treeExecuted is true.

        List<String> rpartParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [er, em, ro, hd, ero]
            : [er, em, ro, erc, hd, ero];

        await executeEvaluation(
          executed: rpartExecuted && treeExecuted,
          parameters: rpartParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for ctree model if it was executed and
        // treeExecuted is true.

        List<String> ctreeParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [ec, em, ro, hd, ero]
            : [ec, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: ctreeExecuted && treeExecuted,
          parameters: ctreeParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for Random Forest model if executed and
        // forest box is ticked.

        List<String> rforestParams =
            datasetRisk == 'NULL' || datasetRisk.isEmpty
                ? [erf, em, ro, hd, ero]
                : [erf, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: randomForestExecuted && forestTicked,
          parameters: rforestParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for Conditional Forest model if executed
        // and forest box is ticked.

        List<String> cforestParams =
            datasetRisk == 'NULL' || datasetRisk.isEmpty
                ? [ecf, em, ro, hd, ero]
                : [ecf, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: conditionalForestExecuted && forestTicked,
          parameters: cforestParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for AdaBoost model if executed and boost
        // box is ticked.

        List<String> adaParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [ea, em, ro, hd, ero]
            : [ea, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: adaBoostExecuted && boostTicked,
          parameters: adaParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for XGBoost model if executed and boost
        // box is ticked.

        List<String> xgbParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [ex, em, ro, hd, ero]
            : [ex, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: xgBoostExecuted && boostTicked,
          parameters: xgbParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for SVM model if executed.

        List<String> svmParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [es, em, ro, hd, ero]
            : [es, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: svmExecuted,
          parameters: svmParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for linear model if executed.

        List<String> linearParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [el, em, ro, hd, ero]
            : [el, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: linearExecuted,
          parameters: linearParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for Neural Network model if executed and
        // neural network box is ticked.

        List<String> nnetParams = datasetRisk == 'NULL' || datasetRisk.isEmpty
            ? [en, em, ro, hd, ero]
            : [en, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: neuralTicked && nnetExecuted,
          parameters: nnetParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        // Execute evaluation for Neural Net model if executed and
        // neural network box is ticked.

        List<String> neuralNetParams =
            datasetRisk == 'NULL' || datasetRisk.isEmpty
                ? [ent, em, ro, hd, ero]
                : [ent, em, ro, erc, hd, ero];

        if (!context.mounted) return;

        await executeEvaluation(
          executed: neuralTicked && neuralNetExecuted,
          parameters: neuralNetParams,
          datasetSplitType: datasetSplitType,
          context: context,
          ref: ref,
        );

        await ref.read(evaluatePageControllerProvider).animateToPage(
              // Index of the second page.
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
      }
    },
    child: const Text('Evaluate'),
  );
}
