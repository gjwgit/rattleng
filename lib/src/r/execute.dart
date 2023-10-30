/// R Scripts: support for running an R command.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-10-18 17:27:10 +1100 Graham Williams>
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

import 'package:rattle/src/models/rattle_model.dart';
import 'package:rattle/src/r/process.dart';
import 'package:rattle/src/r/strip_header.dart';

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

void rExecute(String code, RattleModel rattle) {
  // TODO ANOTHER ARGUMENT AS A LIST OF MAPS FROM STRING TO STRING LIKE
  //
  // [ { 'FILENAME': '/home/kayon/data/weather.csv', ... } ]
  //
  // AND THEN ON THE CODE FOR EACH MAP, RUN
  //
  // code.replaceAll('$MAP','$value')

  // First obtain the text from the script.

  debugPrint("R_EXECUTE: '$code'");

  // Add the code to the rattle state so it will be displayed in the SCRIPT tab.

  rattle.appendScript("\n## -- Generated Code --\n${rStripHeader(code)}\n");

  // Run the code.

  process.stdin.writeln(code);
}
