/// Call upon R to load a dataset.
///
/// Time-stamp: <Tuesday 2024-06-04 09:51:49 +1000 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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
/// Authors: Graham Williams, Yixiang Yin
library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/provider/path.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/source.dart';

/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names having as values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

void rLoadDataset(WidgetRef ref) {
  // Get the path from the provider to identify either a filename or a R package
  // dataset.

  String path = ref.read(pathProvider);

  // TODO 20231018 gjw IF A DATASET HAS ALREADY BEEN LOADED AND NOT YET
  // PROCESSED (dataset_template.R) THEN PROCESS ELSE ASK IF WE CAN OVERWRITE IT
  // AND IF SO DO SO OTHERWISE DO NOTHING.

  debugPrint("R LOAD DATASET:\t'$path'");

  if (path == '' || path == 'rattle::weather') {
    // The default, when we get here and no path has been specified yet, is to
    // load the weather dataset as the demo dataset from R's rattle package.

    rSource(ref, "dataset_load_weather");
  } else if (path.endsWith(".csv")) {
    rSource(ref, "dataset_load_csv");
  } else if (path.endsWith(".txt")) {
    rSource(ref, "dataset_load_txt");

    return;
  } else {
    debugPrint('LOAD_DATASET: PATH NOT RECOGNISED -> ABORT: $path.');

    return;
  }

  // Reset the dataset variables since we have loaded a new dataset
//  rattle.resetDataset();

  rSource(ref, "dataset_prep");

  rExecute(ref, "names(ds)");

  // this shows the data
  rSource(ref, "ds_glimpse");
  debugPrint('R LOAD DATASET:\tLoaded "$path";');
}
