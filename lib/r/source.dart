/// R Scripts: support for running a script.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-10-15 06:36:30 +1100 Graham Williams>
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

import 'package:rattle/models/rattle_model.dart';
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

void rSource(String script, RattleModel rattle) {
  // TODO ANOTHER ARGUMENT AS A LIST OF MAPS FROM STRING TO STRING LIKE
  //
  // [ { 'FILENAME': '/home/kayon/data/weather.csv', ... } ]
  //
  // AND THEN ON THE CODE FOR EACH MAP, RUN
  //
  // code.replaceAll('$MAP','$value')

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
  //
  code = code.replaceAll('VERSION', '0.0.1');

  // HARD CODE FOR NOW BUT EVENTUALLY PASSED IN THROUGH THE FUNCTION CALL AS A
  // MAP AS DESCRIBED ABOVE..

  code = code.replaceAll(
    'VAR_TARGET',
    rattle.normalise ? "rain_tomorrow" : "RainTomorrow",
  );
  code = code.replaceAll('VAR_RISK', rattle.normalise ? "risk_mm" : "RISK_MM");
  code = code.replaceAll('VARS_ID', '"date", "location"');

  code = code.replaceAll('DATA_SPLIT_TR_TU_TE', '0.7, 0.15, 0.15');

  // RPART_BUILD.R

  code = code.replaceAll(' PRIORS', '');
  code = code.replaceAll(' LOSS', '');
  code = code.replaceAll(' MAXDEPTH', '');
  code = code.replaceAll(' MINSPLIT', '');
  code = code.replaceAll(' MINBUCKET', '');
  code = code.replaceAll(' CP', '');

  // RANDOM_FOREST_BUILD.R

  code = code.replaceAll('RF_NUM_TREES', '500');
  code = code.replaceAll('RF_MTRY', '4');
  code = code.replaceAll('RF_NA_ACTION', 'randomForest::na.roughfix');

  // Do we split the dataset? The option is presented on the DATASET GUI, and if set we split the dataset.

  code = code.replaceAll('FILENAME', rattle.path);

  // Do we split the dataset? The option is presented on the DATASET GUI, and if set we split the dataset.

  code = code.replaceAll('SPLIT_DATASET', rattle.partition ? "TRUE" : "FALSE");

  // Do we want to normalise the dataset?

  code =
      code.replaceAll('NORMALISE_NAMES', rattle.normalise ? "TRUE" : "FALSE");

  // Run the code.

  process.stdin.writeln(code);

  // Preapre code to add to the SCRIPT tab.

  code = rStripHeader(code);

  rattle.appendScript("\n## -- $script.R --\n$code");
}
