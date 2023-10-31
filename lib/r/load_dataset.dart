/// Load a dataset into R.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-10-18 17:28:04 +1100 Graham Williams>
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

import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/source.dart';

/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names with values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

void rLoadDataset(RattleModel rattle) {
  // Get the filename from the corresponding widget.

  // final dsPathTextFinder = find.byKey(const Key('ds_path_text'));
  // var dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
  // String filename = dsPathText.controller?.text ?? '';

  String filename = rattle.path;

  // TODO 20231018 gjw IF A DATASET HAS ALREADY BEEN LOADED AND NOT YET
  // PROCESSED (dataset_template.R) THEN PROCESS ELSE ASK IF WE CAN OVERWRITE IT
  // AND IF SO DO SO OTHERWISE DO NOTHING.

  if (filename == '' || filename == 'rattle::weather') {
    // The default is to load the weather dataset as the demo dastaset from R's
    // rattle package.

    rSource("dataset_load_weather", rattle);
  } else if (filename.endsWith(".csv")) {
    debugPrint('LOAD_DATASET: $filename');
    rSource("dataset_load_csv", rattle);
  } else {
    debugPrint('LOAD_DATASET: FILENAME NOT RECOGNISED -> ABORT: $filename.');

    return;
  }

  // Reset the dataset variables since we have loaded a new dataset
  rattle.resetDataset();

  rSource("dataset_prep", rattle);

  // print("${rattle.stdout}\n\nJUST FINISHED DATASET PREP");

  // rattle.setVars(rGetVars(rattle));
  rExecute("names(ds)", rattle);

  // NEED TO SET TARGET, RISK, HERE BEFORE dataset_template.

  // TODO EXTRACT THE LIST OF VARIABLE NAMES AND FOR NOW ASSUME THE LAST IS
  // TARGET AND THERE IS NO RISK VARIABLE AND STORE IN RATTLE STATE

  //rSetupDatasetTemplate(rattle);
  rSource("dataset_template", rattle);
  rSource('ds_glimpse', rattle);
  debugPrint('LOAD_DATASET: LOADED "$filename";');
}
