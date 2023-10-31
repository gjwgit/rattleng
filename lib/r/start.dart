import 'dart:io';

import 'package:flutter/material.dart';

import 'package:rattle/r/process.dart';
//import 'package:rattle/models/rattle_model.dart';

/// Start up the R process and

void rStart(context) async {
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
}
