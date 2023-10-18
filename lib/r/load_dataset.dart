/// Load a dataset into R.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2023-10-19 08:36:33 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rattle/models/dataset.dart';
import 'package:rattle/models/rattle.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/source.dart';

/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names with values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

void rLoadDataset(RattleModel rattle, DatasetModel dataset, String path) {
  // Get the filename from the corresponding widget.

  //RattleModel rattle = Provider.of<RattleModel>(context, listen: false);
  //DatasetModel dataset = Provider.of<DatasetModel>(context, listen: false);

  // final dsPathTextFinder = find.byKey(const Key('ds_path_text'));
  // var dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
  // String filename = dsPathText.controller?.text ?? '';

  dataset.setPath(path);

  // TODO 20231018 gjw IF A DATASET HAS ALREADY BEEN LOADED AND NOT YET
  // PROCESSED (dataset_template.R) THEN PROCESS ELSE ASK IF WE CAN OVERWRITE IT
  // AND IF SO DO SO OTHERWISE DO NOTHING.

  if (path == '' || path == 'rattle::weather') {
    // The default is to load the weather dataset as the demo dastaset from R's
    // rattle package.

    rSource("dataset_load_weather", context);
  } else if (path.endsWith(".csv")) {
    debugPrint('LOAD_DATASET: $path');
    rSource("dataset_load_csv", context);
  } else {
    debugPrint('LOAD_DATASET: PATH NOT RECOGNISED -> ABORT: $path.');

    return;
  }

  // Reset the dataset variables since we have loaded a new dataset
  dataset.reset();

  rSource("dataset_prep", context);

  // print("${rattle.stdout}\n\nJUST FINISHED DATASET PREP");

  // rattle.setVars(rGetVars(rattle));
  rExecute("names(ds)", context);

  // NEED TO SET TARGET, RISK, HERE BEFORE dataset_template.

  // TODO EXTRACT THE LIST OF VARIABLE NAMES AND FOR NOW ASSUME THE LAST IS
  // TARGET AND THERE IS NO RISK VARIABLE AND STORE IN RATTLE STATE

  //rSetupDatasetTemplate(rattle);
  rSource("dataset_template", context);
  rSource('ds_glimpse', context);
  debugPrint('LOAD_DATASET: LOADED "$path";');
}
