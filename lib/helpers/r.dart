/// Suport for running R scripts.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-08-28 08:40:07 +1000 Graham Williams>
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

import 'dart:convert' show utf8;
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

// ignore: prefer_typing_uninitialized_variables
var process;

void rStart() async {
  // A little unfriendly to kill all R instances. Might only work on Linux
  // too. Only do this for now!

  debugPrint("R: KILLING ALL EXISTING R WHICH MAY NOT BE A NICE THING TO DO");

  process = await Process.start('killall', ["R"]);

  // Start up an R process from the command line.

  debugPrint("R: STARTING UP A NEW R PROCESS");

  process = await Process.start('R', ["--no-save"]);

  // Output generted by the process' stderr and stdout is
  // captured here to the Logging tab of Flutter DevTools.
  //
  // 20230824 TODO gjw How to stop it being displayed onto the console? It's
  // okay during development but for production it should not be displaying this
  // on the console. Just in DevTools is good.

  process.stdout.transform(utf8.decoder).forEach(debugPrint);
  process.stderr.transform(utf8.decoder).forEach(debugPrint);

  // Read the main R startup code from the script file.

  debugPrint("R: SOURCE 'main.R'");

  String code = File("assets/r/main.R").readAsStringSync();

  // Populate the <<TIMESTAMP>>.

  int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
  String formattedTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(DateTime.fromMillisecondsSinceEpoch(currentTimeStamp));
  code = code.replaceAll('<<TIMESTAMP>>', formattedTimeStamp);

  // Populate the <<VERSION>>.

  PackageInfo info = await PackageInfo.fromPlatform();
  code = code.replaceAll('<<VERSION>>', info.version);

  // Populate the <<USER>>. Bit it seems to need to use Firebase. Too much
  // trouble just for the user name.

  // User currentUser = await FirebaseAuth.instance.currentUser!;
  // code = code.replaceAll('<<USER>>', currentUser.displayName ?? 'unknown');

  // Run the code.

  process.stdin.writeln(code);

  // TODO PUT THE CODE INTO THE LOG
}

void rSource(String script) {
  // We want another argument as a list of maps from String to String like
  //
  // [ { 'FILENAME': '/home/kayon/data/weather.csv', ... } ]
  //
  // and then on the code for each map, run
  //
  // code.replaceAll('<<$map>>','$value')

  // First obtain the text from the script.

  debugPrint("R: RUNNING THE CODE IN SCRIPT FILE '$script.R'");

  var code = File("assets/r/$script.R").readAsStringSync();

  // Process template variables. HARD CODED FOR NOW UNTIL WE PASS IN THE
  // KEY:VALUE MAPPINGS.

  code = code.replaceAll('<<VAR_TARGET>>', "rain_tomorrow");
  code = code.replaceAll('<<VAR_RISK>>', "risk_mm");
  code = code.replaceAll('<<VARS_ID>>', '"date", "location"');

  code = code.replaceAll('<<DATA_SPLIT_TR_TU_TE>>', '0.7, 0.15, 0.15');

  // SIMPLY REMOVE THESE DIRECTIVES FOR NOW UNTIL WE PASS IN A DIRECTIVE TO OR
  // NOT TO INCLUDE THESE BLOCKS.

  code = code.replaceAll('<<BEGIN_NORMALISE_NAMES>>', "");
  code = code.replaceAll('<<END_NORMALISE_NAMES>>', "");
  code = code.replaceAll('<<BEGIN_SPLIT_DATASET>>', "");
  code = code.replaceAll('<<END_SPLIT_DATASET>>', "");

  // Run the code.

  process.stdin.writeln(code);

  // Add the code to the LOG tab.

  //var log = find.byKey(const Key('log_text'));
  //var elog = log.evaluate().first.widget as TextField;

  //elog.controller?.text += File("assets/r/$script.R").readAsStringSync();
}

//               cmd = "getwd()";
// process.stdin.writeln(cmd);
// cmd = 'ds <- read_csv("weather.csv")';
// process.stdin.writeln(cmd);
// cmd = 'ds %>% ggplot(aes(x=WindDir3pm)) + geom_bar()';
// process.stdin.writeln(cmd);
// cmd = 'ggsave("myplot.pdf", width=11, height=7)';
// process.stdin.writeln(cmd);

//               Process.run("xdg-open", ["myplot.pdf"]);
