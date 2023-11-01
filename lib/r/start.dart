/// Initiate the R process and setup capture of its output.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Time-stamp: <Thursday 2023-11-02 08:10:33 +1100 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/r/process.dart';
import 'package:rattle/utils/update_script.dart';

/// Start up the R process and set up the capture of stderr and stdout.

void rStart(WidgetRef ref) async {
  // Start up an R process from the command line.

  debugPrint("R: STARTING UP A NEW R PROCESS");

  process = await Process.start('R', ["--no-save"]);

  // Output generted by the process' stderr and stdout is
  // captured here to the SCRIPT tab of Flutter DevTools.
  //
  // 20230824 TODO gjw Currently it also goes to the console. How to stop it
  // being displayed onto the console? It's okay during development but for
  // production it should not be displaying this on the console. Just in
  // DevTools is good.
  //
  // Comment out the following to then only print debugPrint messages to the
  // console.

  //process.stdout.transform(utf8.decoder).forEach(debugPrint);
  //process.stderr.transform(utf8.decoder).forEach(debugPrint);

//  RattleModel rattle = Provider.of<RattleModel>(context, listen: false);

//  process.stdout.transform(utf8.decoder).forEach(rattle.appendStdout);
//  process.stderr.transform(utf8.decoder).forEach(rattle.appendStderr);

  // Read the main R startup code from the script file.

  debugPrint("R: SOURCE 'main.R'");

  String code = File("assets/r/main.R").readAsStringSync();

  // Populate the <<USER>>. Bit it seems to need to use Firebase. Too much
  // trouble just for the user name.

  // User currentUser = await FirebaseAuth.instance.currentUser!;
  // code = code.replaceAll('<<USER>>', currentUser.displayName ?? 'unknown');

  // Run the code.

  process.stdin.writeln(code);

  // Add the code to the script.

  updateScript(ref, code);
}
