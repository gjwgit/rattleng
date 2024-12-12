/// Initiate the R sub-process and setup the capture of its output.
//
// Time-stamp: <Thursday 2024-12-12 16:34:13 +1100 Graham Williams>
//
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

library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:rattle/providers/pty.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/r/strip_comments.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/update_script.dart';

/// Start up the R sub-process and set up the capture of stderr and stdout.

void rStart(BuildContext context, WidgetRef ref) async {
  // Start up an R process from the command line.

  // process = await Process.start('R', ["--no-save"]);

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

  // process.stdout.transform(utf8.decoder).forEach(
  //       (String txt) => ref.read(stdoutProvider.notifier).state =
  //           ref.read(stdoutProvider) + txt,
  //     );
  // process.stderr.transform(utf8.decoder).forEach(
  //       (String txt) => ref.read(stderrProvider.notifier).state =
  //           ref.read(stderrProvider) + txt,
  //     );

  // Run the main R startup code from the script file.

  rSource(context, ref, ['session_setup']);

  // 20241212 gjw I used to do the following rather than the above
  // rSource(). However, rSource seems to work so go with that (since it expands
  // the TEMPLATE variables properly. Monitor it to see if there was a reason we
  // needed to mimic rSource() as below.

  // const asset = 'assets/r/session_setup.R';
  // String code = await DefaultAssetBundle.of(context).loadString(asset);
  // PackageInfo info = await PackageInfo.fromPlatform();
  // code = code.replaceAll('VERSION', info.version);

  // // 20240615 gjw Previously the code used File() to access the asset file which
  // // worked fine in development but failed on a deployment. Thus I moved to the
  // // async reading from the asset bundle.
  // //
  // // String code = File('assets/r/main.R').readAsStringSync();

  // // Populate the <<USER>>. Bit it seems to need to use Firebase. Too much
  // // trouble just for the user name.

  // // User currentUser = await FirebaseAuth.instance.currentUser!;
  // // code = code.replaceAll('<<USER>>', currentUser.displayName ?? 'unknown');

  // // Because we want to modify a provider here we note that the widget tree is
  // // still building. Modifying a provider inside of the widget life-cycle
  // // (build, initState, etc) is not allowed, as it could lead to an inconsistent
  // // UI state. For example, two widgets could listen to the same provider, but
  // // incorrectly receive different states. We resolve that here by delaying the
  // // modification by encapsulating it within a `Future(() {...})`.  This will
  // // perform the update after the widget tree is done building. 20231104 gjw

  // // 20240812 gjw Try using an await here so we wait for the console to
  // // startup. Seems to have a slight delay on Linux with a all black
  // // screen. Let's see what it does on Windows.

  // await Future(() async {
  //   // Add the code to the SCRIPT tab.

  //   updateScript(ref, code);

  //   // Strip the code of comments.

  //   code = rStripComments(code);

  //   debugText('R START', 'session_setup.R');

  //   ref.read(ptyProvider).write(const Utf8Encoder().convert(code));
  // });
}
