/// R Scripts: support for running a script.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2023-09-15 07:05:02 +1000 Graham Williams>
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

import 'package:intl/intl.dart';

import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/helpers/r_process.dart';
import 'package:rattle/helpers/r_strip_header.dart';

/// Run the R [script] and append to the [rattle] script.

void rSource(String script, RattleModel rattle) {
  // TODO ANOTHER ARGUMENT AS A LIST OF MAPS FROM STRING TO STRING LIKE
  //
  // [ { 'FILENAME': '/home/kayon/data/weather.csv', ... } ]
  //
  // AND THEN ON THE CODE FOR EACH MAP, RUN
  //
  // code.replaceAll('<<$map>>','$value')

  // First obtain the text from the script.

  debugPrint("R: RUNNING THE CODE IN SCRIPT FILE '$script.R'");

  var code = File("assets/r/$script.R").readAsStringSync();

  // Process template variables.

  // HARD CODED FOR NOW UNTIL WE PASS IN THE
  // KEY:VALUE MAPPINGS.

  int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
  String formattedTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(DateTime.fromMillisecondsSinceEpoch(currentTimeStamp));

  code = code.replaceAll('<<TIMESTAMP>>', formattedTimeStamp);

  // Populate the <<VERSION>>.

  //PackageInfo info = await PackageInfo.fromPlatform();
  //code = code.replaceAll('<<VERSION>>', info.version);

  // HARD CODE FOR NOW AS ABOVE REQUIRES ASYNC AND RETURNS FUTURE.

  code = code.replaceAll('<<VERSION>>', '0.0.1');

  code = code.replaceAll('<<VAR_TARGET>>', "rain_tomorrow");
  code = code.replaceAll('<<VAR_RISK>>', "risk_mm");
  code = code.replaceAll('<<VARS_ID>>', '"date", "location"');

  code = code.replaceAll('<<DATA_SPLIT_TR_TU_TE>>', '0.7, 0.15, 0.15');

  // RPART_BUILD.R

  code = code.replaceAll('<<PRIORS>>', '');
  code = code.replaceAll('<<LOSS>>', '');
  code = code.replaceAll('<<MINSPLIT>>', '');
  code = code.replaceAll('<<MINBUCKET>>', '');
  code = code.replaceAll('<<CP>>', '');

  // SIMPLY REMOVE THESE DIRECTIVES FOR NOW UNTIL WE PASS IN A DIRECTIVE TO OR
  // NOT TO INCLUDE THESE BLOCKS.

  code = code.replaceAll('<<BEGIN_NORMALISE_NAMES>>', "");
  code = code.replaceAll('<<END_NORMALISE_NAMES>>', "");
  code = code.replaceAll('<<BEGIN_SPLIT_DATASET>>', "");
  code = code.replaceAll('<<END_SPLIT_DATASET>>', "");

  // Run the code.

  process.stdin.writeln(code);

  // Preapre code to add to the SCRIPT tab.

  code = rStripHeader(code);

  rattle.appendScript("\n## -- $script.R --\n$code");
}
