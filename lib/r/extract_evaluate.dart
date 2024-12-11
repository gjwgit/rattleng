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

String _basicTemplate(
  String log,
  String evaluateDataset,
  WidgetRef ref,
) {
  bool treeExecuted = ref.watch(rpartTreeEvaluateProvider);
  bool boostExecuted = ref.watch(boostEvaluateProvider);
  bool forestExecuted = ref.watch(forestEvaluateProvider);

  String hdr;
  String mdr;
  String hdc;
  String mdc;
  String hda;
  String mda;
  String hdx;
  String mdx;
  String hdrf;
  String mdrf;

  hdr =
      'Error matrix for the RPART Decision Tree model [$evaluateDataset] (counts)';
  mdr =
      'Error matrix for the RPART Decision Tree model [$evaluateDataset] (proportions)';
  hdc =
      'Error matrix for the CTREE Decision Tree model [$evaluateDataset] (counts)';
  mdc =
      'Error matrix for the CTREE Decision Tree model [$evaluateDataset] (proportions)';
  hda = 'Error matrix for the ADABOOST model [$evaluateDataset] (counts)';
  mda = 'Error matrix for the ADABOOST model [$evaluateDataset] (proportions)';
  hdx = 'Error matrix for the XGBOOST model [$evaluateDataset] (counts)';
  mdx = 'Error matrix for the XGBOOST model [$evaluateDataset] (proportions)';
  hdrf = 'Error matrix for the RANDOM FOREST model [$evaluateDataset] (counts)';
  mdrf =
      'Error matrix for the RANDOM FOREST model [$evaluateDataset] (proportions)';

  // Now extract the output from particular commands.

  String sz = '',
      cm = '',
      cc = '',
      cp = '',
      ca = '',
      pa = '',
      cx = '',
      px = '',
      crf = '',
      prf = '';

  sz = rExtract(
    log,
    'print(rpart_cem)',
  );
  cm = rExtract(
    log,
    'print(rpart_per)',
  );
  cc = rExtract(
    log,
    'print(ctree_cem)',
  );
  cp = rExtract(
    log,
    'print(ctree_per)',
  );
  ca = rExtract(
    log,
    'print(adaboost_cem)',
  );
  pa = rExtract(
    log,
    'print(adaboost_per)',
  );
  cx = rExtract(
    log,
    'print(xgboost_cem)',
  );
  px = rExtract(
    log,
    'print(xgboost_per)',
  );
  crf = rExtract(
    log,
    'print(rforest_cem)',
  );
  prf = rExtract(
    log,
    'print(cforest_per)',
  );

  // Obtain the current timestamp.

  final String ts = timestamp();

  // Build the result.

  String result = '';

  if (sz != '' && cm != '' && treeExecuted) {
    result = '$hdr\n\n'
        '\n$sz\n\n'
        '$mdr\n\n'
        '\n$cm\n\n';
  }

  if (cc != '' && cp != '' && treeExecuted) {
    result = '$result\n'
        '$hdc\n\n'
        '$cc\n\n'
        '$mdc\n\n'
        '$cp\n\n';
  }
  if (ca != '' && pa != '' && boostExecuted) {
    result = '$result\n'
        '$hda\n\n'
        '$ca\n\n'
        '$mda\n\n'
        '$pa\n\n';
  }

  if (cx != '' && px != '' && boostExecuted) {
    result = '$result\n'
        '$hdx\n\n'
        '$cx\n\n'
        '$mdx\n\n'
        '$px\n\n';
  }

  if (crf != '' && prf != '' && forestExecuted) {
    result = '$result\n'
        '$mdrf\n\n'
        '$crf\n\n'
        '$hdrf\n\n'
        '$prf\n\n';
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
