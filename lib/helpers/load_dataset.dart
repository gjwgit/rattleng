import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart' show find;

import 'r.dart' show rSource;
/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names with values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

// SHOULD BE void loadDataset(String filename) {
void loadDataset(String filename) {
  // Get the filename from the corresponding widget.

  // final dsPathTextFinder = find.byKey(const Key('ds_path_text'));
  // var dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
  // String filename = dsPathText.controller?.text ?? '';

//  String filename = getIt.get....
//  print(filename)

  // IF A DATASET HAS ALREADY BEEN LOADED AND NOT YET PROCESSED
  // (data_template.R) THEN PROCESS ELSE ASK IF WE CAN OVERWRITE IT AND IF SO DO
  // SO OTHERWISE DO NOTHING.

  if (filename == '' || filename == 'rattle::weather') {
    debugPrint('LOAD_DATASET: rattle::weather');
    rSource("data_load_weather");
  } else {
    debugPrint('LOAD_DATASET: FILENAME IS NOT RECOGNISED SO ABORT');
    return;
  }
  debugPrint('LOAD_DATASET: FILENAME IS NOT EMPTY SO FOR NOW:');
  rSource(
    "data_template",
    // {
    //   "VAR_TARGET": "rain_tomorrow",
    //   "VAR_RISK": "risk_mm",
    //   "VARS_ID": '"date", "location"'
    // }
  );
  rSource('ds_summarise');
  debugPrint(
    'LOAD_DATASET: OTHERWISE WE SHOULD RUN APPROPRIATE R SCRIPT '
    'TO LOAD DATA FROM -> "$filename";',
  );
}
