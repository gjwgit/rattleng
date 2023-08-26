import 'dart:convert' show utf8;
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

var process;

void rStart() async {
  // A little unfriendly to kill all R instances. Might only work on Linux
  // too. Only do this for now!

  print("R: KILLING ALL EXISTING R WHICH MAY NOT BE A NICE THING TO DO");

  process = await Process.start('killall', ["R"]);

  // Start up an R process from the command line.

  print("R: STARTING UP A NEW R PROCESS");

  process = await Process.start('R', ["--no-save"]);

  // Output generted by the process is sent to stderr (or stdout if desired) to
  // capture everything to the Logging tab of Flutter DevTools.
  //
  // 20230824 TODO gjw How to stop it being displayed onto the console? It's
  // okay during development but for production it should not be displaying this
  // on the console. Just in DevTools is good.

  // process.stdout.transform(utf8.decoder).forEach(print);
  process.stderr.transform(utf8.decoder).forEach(print);

  // Read the main R startup code from the script file.

  print("R: SOURCE 'main.R'");

  String code = File("assets/scripts/main.R").readAsStringSync();

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

  print("R: RUNNING THE CODE IN SCRIPT FILE '$script.R'");

  var code = File("assets/scripts/$script.R").readAsStringSync();

  // Process template variables.

  code = code.replaceAll('<<VAR_TARGET>>', "rain_tomorrow");
  code = code.replaceAll('<<VAR_RISK>>', "risk_mm");
  code = code.replaceAll('<<VARS_ID>>', '"date", "location"');

  code = code.replaceAll('<<BEGIN_SPLIT_DATASET>>', "");
  code = code.replaceAll('<<END_SPLIT_DATASET>>', "");
  code = code.replaceAll('<<DATA_SPLIT_TR_TU_TE>>', '0.7, 0.15, 0.15');

  // Run the code.

  process.stdin.writeln(code);

  // Add the code to the LOG tab.

  //var log = find.byKey(const Key('log_text'));
  //var elog = log.evaluate().first.widget as TextField;

  //elog.controller?.text += File("assets/scripts/$script.R").readAsStringSync();
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
