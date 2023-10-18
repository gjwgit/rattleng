/// R Scripts: support for running a script.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2023-10-19 08:25:36 +1100 Graham Williams>
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rattle/models/dataset.dart';
import 'package:rattle/models/rattle.dart';
import 'package:rattle/r/process.dart';
import 'package:rattle/r/strip_header.dart';
import 'package:rattle/helpers/timestamp.dart';

/// Run the R [script] and append to the [rattle] script.
///
/// Various PARAMETERS that are found in the R script will be replaced with
/// actual values before the code is run. An early approach was to wrap the
/// PARAMETERS within anlg brackets, as in <<PARAMETERS>> but then the R scripts
/// do not run standalone. Whlist it did ensure the parameters were properly
/// mapped, it is useful to be able to run the scripts as is outside of
/// rattleNG. So decided to remove the angle brackets. The scripts still can not
/// tun standalone as such since they will have undefined vairables, but we can
/// define the variables and then run the scripts.

void rSource(String script, BuildContext context) {
  // TODO ANOTHER ARGUMENT AS A LIST OF MAPS FROM STRING TO STRING LIKE
  //
  // [ { 'FILENAME': '/home/kayon/data/weather.csv', ... } ]
  //
  // AND THEN ON THE CODE FOR EACH MAP, RUN
  //
  // code.replaceAll('$MAP','$value')

  RattleModel rattle = Provider.of<RattleModel>(context, listen: false);
  DatasetModel dataset = Provider.of<DatasetModel>(context, listen: false);

  // First obtain the text from the script.

  debugPrint("R_SOURCE: '$script.R'");

  var code = File("assets/r/$script.R").readAsStringSync();

  // Process template variables. This is done here rather than passing the
  // TIMESTAMP parameter through the map.

  code = code.replaceAll('TIMESTAMP', timestamp());

  // Populate the VERSION.

  // PackageInfo info = await PackageInfo.fromPlatform();
  // code = code.replaceAll('VERSION', info.version);
  //
  // THIS FAILS FOR NOW AS REQUIRES A FUTURE SO FIX THE VERSION FOR NOW

  code = code.replaceAll('VERSION', '0.0.1');

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  code = code.replaceAll('FILENAME', dataset.path);

  // TODO if (script.contains('^dataset_')) {

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  code = code.replaceAll('SPLIT_DATASET', dataset.partition ? "TRUE" : "FALSE");

  // Do we want to normalise the dataset? The option is presented on the DATASET
  // GUI, and if set we normalise the dataset's variable names.

  code =
      code.replaceAll('NORMALISE_NAMES', dataset.normalise ? "TRUE" : "FALSE");

  // TODO 20231016 gjw HARD CODE FOR NOW BUT EVENTUALLY PASSED IN THROUGH THE
  // FUNCTION CALL AS A MAP AS DESCRIBED ABOVE..

  // TODO 20231016 gjw THES SHOULD BE SET IN THE DATASET TAB:
  //
  // dataset.target
  // dataset.risk
  // dataset.id
  // dataset.split

  code = code.replaceAll(
    'VAR_TARGET',
    dataset.normalise ? "rain_tomorrow" : "RainTomorrow",
  );
  code = code.replaceAll('VAR_RISK', dataset.normalise ? "risk_mm" : "RISK_MM");
  code = code.replaceAll('VARS_ID', '"date", "location"');

  code = code.replaceAll('DATA_SPLIT_TR_TU_TE', '0.7, 0.15, 0.15');

  // TODO if (script == 'model_build_rpart')) {

  // TODO 20231016 gjw THESE SHOULD BE SET IN THE MODEL TAB AND ARE THEN
  // REPLACED WITHING model_build_rpart.R

  code = code.replaceAll(' PRIORS', '');
  code = code.replaceAll(' LOSS', '');
  code = code.replaceAll(' MAXDEPTH', '');
  code = code.replaceAll(' MINSPLIT', '');
  code = code.replaceAll(' MINBUCKET', '');
  code = code.replaceAll(' CP', '');

  // TODO if (script == 'model_build_random_forest')) {

  code = code.replaceAll('RF_NUM_TREES', '500');
  code = code.replaceAll('RF_MTRY', '4');
  code = code.replaceAll('RF_NA_ACTION', 'randomForest::na.roughfix');

  // Add the code to the rattle state so it will be displayed in the SCRIPT tab.

  rattle.appendScript("\n## -- $script.R --\n${rStripHeader(code)}");

  // Run the code.

  process.stdin.writeln(code);
}
