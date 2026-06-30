/// A provider of the pseudo terminal running R.
///
/// Time-stamp: "Wednesday 2025-09-24 08:27:18 +1000 Graham Williams"
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams
library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:xterm/xterm.dart';

import 'package:rattle/app.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/terminal.dart';
import 'package:rattle/utils/clean_string.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/detect_missing_package.dart';
import 'package:rattle/utils/show_ok.dart';

final ptyProvider = StateProvider<Pty>((ref) {
  // Create a pseudo termminal provider.

  Terminal terminal = ref.watch(terminalProvider);
  debugText('  STARTUP', shell);
  Pty pty = Pty.start(shell, arguments: ['--no-save']);

  // Options
  //   columns: terminal.viewWidth,
  //   rows: terminal.viewHeight,

  // Add a listener of the pty to show the pty output within the enclosing
  // terminal. I also want to capture the output for parsing in the app.

  // Guard so we only pop up the missing-package advice once per episode rather
  // than on every subsequent chunk of output that still contains the error
  // text in the accumulated stdout. (gjw 20260630)

  bool missingPackageNotified = false;

  pty.output.cast<List<int>>().transform(const Utf8Decoder()).listen((data) {
    terminal.write(data);
    // debugPrint('update stdoutProvider');
    final String accumulated = ref.read(stdoutProvider) + cleanString(data);
    ref.read(stdoutProvider.notifier).state = accumulated;

    // If R reports a package that is not installed (or fails to load), the
    // downstream objects are never created and the display panel renders blank
    // (the "grey screen"), or throws in debug mode. Catch that here, where all
    // R output flows through, and advise the user to install the required R
    // packages, just as the PACKAGE INSTALLATIONS button does. We scan the
    // accumulated output (the error phrase can straddle two pty chunks) and the
    // `missingPackageNotified` guard ensures we pop up only once. (gjw 20260630)

    if (!missingPackageNotified) {
      final String? missing = detectMissingPackage(accumulated);
      if (missing != null) {
        missingPackageNotified = true;

        // Show the advice via the global navigator. We use `currentState` and
        // its `mounted` check (rather than a captured `BuildContext`) so the
        // lookup is fresh at the moment of use, satisfying
        // `use_build_context_synchronously`. (gjw 20260630)

        final NavigatorState? nav = navigatorKey.currentState;
        if (nav != null && nav.mounted) {
          showOk(
            context: nav.context,
            title: 'R Package Not Installed',
            content: '''

            Rattle tried to use the R package **$missing** but it is not
            installed (or failed to load) on your system. The current action
            could not complete and so the panel may remain blank.

            Please install the required **R Packages** and then try again. You
            can do this from the **R Package Installations** button (the
            *download* icon at the top right of the Rattle window), or install
            the packages directly in R before starting Rattle.

            Check the **Console** tab for the full R error message.

            ''',
          );
        }
      }
    }
  });

  pty.exitCode.then((code) {
    terminal.write('the process exited with exit code $code');
  });

  terminal.onOutput = (data) {
    // This gets called when a user types into the R console. So typing the
    // command `ls()` in the R console the command is echoed in the R
    // console. This is not capturing the output from the console.

    pty.write(const Utf8Encoder().convert(data));
  };

  terminal.onResize = (w, h, pw, ph) {
    pty.resize(h, w);
  };

  return pty;
});

/// We are interested in running R on whichever desktop.
///
/// Linux and MacOS desktops initiate R simply through the R command. Windows
/// does an R.exe.

// Rewrite code to remove nesting to pass lint.

String get shell {
  if (Platform.isWindows) {
    return 'R.exe';
  }
  if (Platform.isMacOS) {
    return '/usr/local/bin/R';
  }
  if (Platform.isAndroid) {
    // 20250113 gjw Trying a UserLand install of R on Android.

    return '/data/data/tech.ula/files/support/busybox run-parts /data/data/tech.ula/files/support/executables -- /usr/bin/R';
  }

  return '/usr/bin/R';
}
