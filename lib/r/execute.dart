/// R Scripts: Support for running an R command.
///
/// Time-stamp: <Saturday 2023-11-04 18:30:11 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
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
/// Authors: Graham Williams

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/provider/pty.dart';
import 'package:rattle/r/process.dart';
import 'package:rattle/r/strip_header.dart';
import 'package:rattle/utils/update_script.dart';

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

void rExecute(WidgetRef ref, String code) {
  debugPrint("R_EXECUTE: '$code'");

  // Add the code to the script provider so it will be displayed in the script
  // tab.

  updateScript(
    ref,
    "\n${'#' * 72}\n## -- Generated Code --\n${'#' * 72}"
    "\n${rStripHeader(code)}\n",
  );

  // Run the code.

  ref.read(ptyProvider).write(const Utf8Encoder().convert(code));

  // TODO 20231104 gjw OLD R PROCESS TO BE REMOVED.

  // process.stdin.writeln(code);
}
