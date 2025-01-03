/// Utility to extract the EXECUTE from R log.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-09-27 05:39:57 +1000 Graham Williams>
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

import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/timestamp.dart';

/// Constructs a formatted result string using output from various model evaluations.
///
/// Takes in a [log] string, an [evaluateDataset] identifier, and a [ref] to
/// model evaluation states. It returns a formatted string that contains relevant
/// evaluation results.

String _basicTemplate(
  String log,
  String evaluateDataset,
  WidgetRef ref,
) {
  // Check which models and evaluation options have been selected or executed.

  bool rpartTreeExecuted = ref.watch(rpartTreeEvaluateProvider);
  bool cTreeExecuted = ref.watch(cTreeEvaluateProvider);

  bool boostExecuted = ref.watch(boostEvaluateProvider);
  bool forestExecuted = ref.watch(forestEvaluateProvider);
  bool svmExecuted = ref.watch(svmEvaluateProvider);
  bool nnetExecuted = ref.watch(nnetEvaluateProvider);

  // Define header strings for various model error matrices (counts and proportions).

  String hdr =
      'Error matrix for the RPART Decision Tree model [$evaluateDataset] (counts)';
  String mdr =
      'Error matrix for the RPART Decision Tree model [$evaluateDataset] (proportions)';
  String hdc =
      'Error matrix for the CTREE Decision Tree model [$evaluateDataset] (counts)';
  String mdc =
      'Error matrix for the CTREE Decision Tree model [$evaluateDataset] (proportions)';
  String hda =
      'Error matrix for the ADABOOST model [$evaluateDataset] (counts)';
  String mda =
      'Error matrix for the ADABOOST model [$evaluateDataset] (proportions)';
  String hdx = 'Error matrix for the XGBOOST model [$evaluateDataset] (counts)';
  String mdx =
      'Error matrix for the XGBOOST model [$evaluateDataset] (proportions)';
  String hdrf =
      'Error matrix for the RANDOM FOREST model [$evaluateDataset] (counts)';
  String mdrf =
      'Error matrix for the RANDOM FOREST model [$evaluateDataset] (proportions)';
  String hdcf =
      'Error matrix for the CONDITIONAL FOREST model [$evaluateDataset] (counts)';
  String mdcf =
      'Error matrix for the CONDITIONAL FOREST model [$evaluateDataset] (proportions)';

  String ecsvm = 'Error matrix for the SVM model [$evaluateDataset] (counts)';
  String epsvm =
      'Error matrix for the SVM model [$evaluateDataset] (proportions)';

  String ennc = 'Error matrix for the NNET model [$evaluateDataset] (counts)';
  String ennp =
      'Error matrix for the NNET model [$evaluateDataset] (proportions)';

  // Extract results from the log for each model's error matrices.
  // Extract the count data from the log and remove the first line.

  String crc = rExtract(
    log,
    '> rpart_${evaluateDataset}_COUNT',
  );

  String crp = rExtract(
    log,
    '> rpart_${evaluateDataset}_PROP',
  );
  String cc = rExtract(
    log,
    '> ctree_${evaluateDataset}_COUNT',
  );
  String cp = rExtract(
    log,
    '> ctree_${evaluateDataset}_PROP',
  );
  String ca = rExtract(log, '> adaboost_${evaluateDataset}_COUNT');
  String pa = rExtract(log, '> adaboost_${evaluateDataset}_PROP');
  String cx = rExtract(log, '> xgboost_${evaluateDataset}_COUNT');
  String px = rExtract(log, '> xgboost_${evaluateDataset}_PROP');
  String crf = rExtract(log, '> randomForest_${evaluateDataset}_COUNT');
  String prf = rExtract(log, '> randomForest_${evaluateDataset}_PROP');
  String ccf = rExtract(log, '> cforest_${evaluateDataset}_COUNT');
  String pcf = rExtract(log, '> cforest_${evaluateDataset}_PROP');
  String csvm = rExtract(log, '> svm_${evaluateDataset}_COUNT');
  String psvm = rExtract(log, '> svm_${evaluateDataset}_PROP');
  String cnc = rExtract(log, 'print(nnet_cem)');
  String cnp = rExtract(log, 'print(nnet_per)');

  // Obtain the current timestamp for logging purposes.

  final String ts = timestamp();

  // Initialize the result string that will be built based on available model outputs.

  String result = '';

  // Append RPART model results if available and executed.

  if (crc != '' && crp != '' && rpartTreeExecuted) {
    result = '$hdr\n\n'
        '\n$crc\n\n'
        '$mdr\n\n'
        '\n$crp\n\n';
  }

  // Append CTREE model results if available and tree execution is confirmed.

  if (cc != '' && cp != '' && cTreeExecuted) {
    result = '$result\n'
        '$hdc\n\n'
        '$cc\n\n'
        '$mdc\n\n'
        '$cp\n\n';
  }

  // Append RANDOM FOREST model results if available and forest option is enabled.

  if (crf != '' && prf != '' && forestExecuted) {
    result = '$result\n'
        '$mdrf\n\n'
        '$crf\n\n'
        '$hdrf\n\n'
        '$prf\n\n';
  }

  // Append CONDITIONAL FOREST model results if available and forest option is enabled.

  if (ccf != '' && pcf != '' && forestExecuted) {
    result = '$result\n'
        '$mdcf\n\n'
        '$ccf\n\n'
        '$hdcf\n\n'
        '$pcf\n\n';
  }

  // Append ADABOOST model results if available and boosting is enabled.

  if (ca != '' && pa != '' && boostExecuted) {
    result = '$result\n'
        '$hda\n\n'
        '$ca\n\n'
        '$mda\n\n'
        '$pa\n\n';
  }

  // Append XGBOOST model results if available and boosting is enabled.

  if (cx != '' && px != '' && boostExecuted) {
    result = '$result\n'
        '$hdx\n\n'
        '$cx\n\n'
        '$mdx\n\n'
        '$px\n\n';
  }

  // Append SVM model results if available and SVM is executed.

  if (csvm != '' && psvm != '' && svmExecuted) {
    result = '$result\n'
        '$ecsvm\n\n'
        '$csvm\n\n'
        '$epsvm\n\n'
        '$psvm\n\n';
  }

  // Append NNET model results if available and NNET is executed.

  if (cnc != '' && cnp != '' && nnetExecuted) {
    result = '$result\n'
        '$ennc\n\n'
        '$cnc\n\n'
        '$ennp\n\n'
        '$cnp\n\n';
  }

  result = '$result\n'
      'Rattle timestamp: $ts';

  return result;
}

String rExtractEvaluate(
  String log,
  String evaluateDataset,
  WidgetRef ref,
) {
  // Extract from the R log those lines of output from the evaluate.

  String extract = _basicTemplate(
    log,
    evaluateDataset,
    ref,
  );

  return extract;
}
