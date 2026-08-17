/// Shake, rattle, and roll for the data scientist.
///
/// Time-stamp: "Wednesday 2025-09-24 08:28:53 +1000 Graham Williams"
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/app.dart';
import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/features/dataset/load_path.dart';
import 'package:rattle/providers/pty.dart';
import 'package:rattle/utils/is_desktop.dart';
import 'package:rattle/utils/is_production.dart';
import 'package:rattle/utils/show_error.dart';
import 'package:rattle/utils/window_size.dart';

Future<bool> checkRInstallation() async {
  // Try to run the R command to check its availability.

  // 20250113 gjw Exploring Andriod deployment. For now ignore the check for R
  // installed.

  if (Platform.isAndroid) return true;

  // 20250924 adiar11 On macOS Rattle fails to launch when double-clicked if we
  // simply try to run R here. It only launches correctly when run from the
  // command line (`open rattle.app` or by executing the binary directly).
  //
  // The root cause is the system's PATH environment variable. When launched
  // from the Finder, the app gets a minimal PATH that does not include
  // `/usr/local/bin`, where the R executable is typically located, particularly
  // with homebrew installations. As a result, the app cannot find the R process
  // and crashes silently before a window can appear.
  //
  // When launching the app from the Terminal, the app inherits the shell's
  // PATH, which includes /usr/local/bin, so it can find R and runs perfectly.
  //
  // We need to make the app independent of the launch environment. By using
  // `Process.run()` here with an absolute path to the executable the app
  // launches perfectly with a double-click.
  //
  // We need to fix the absolute path for different installations of R. For now
  // we check for macOs and assume `/usr/local/bin/R` but eventually we need to
  // check for locations if not found in PATH.

  try {
    final result = await Process.run(shell, ['--version']);

    // Check if "R version" is present in the output.

    return result.exitCode == 0;
  } catch (e) {
    // R is not installed or not in PATH.

    return false;
  }
}

/// What Rattle accepts on the command line.
///
/// Keep this in step with the same message in
/// `linux/my_application.cc`, which answers `--help` there before any window is
/// created. Adding an argument means teaching both anyway. (gjw 20260817)

String usage(String name) => '''
Usage: $name [OPTIONS] [FILE]

Rattle: Data Science with R.

Options:
  -h, --help     Report this message and exit.
  -v, --version  Report the version and exit.

FILE is a csv, xlsx, or txt dataset to load on startup, rather
than loading it through the DATASET button.

Visit https://rattle.togaware.com for details.''';

/// Whether [arg] is one that the desktop itself added, rather than the user.
///
/// 20260817 gjw macOS hands an app arguments of its own when it is launched
/// from the Finder or from Xcode, `-psn_0_...` being the process serial number
/// and `-NSDocumentRevisionsDebugMode` and `-ApplePersistenceIgnoreState` being
/// debugging settings. Reporting those as a mistake would stop Rattle starting
/// at all for anyone launching it the ordinary way.

bool isLaunchArgument(String arg) =>
    arg.startsWith('-psn_') ||
    arg.startsWith('-NS') ||
    arg.startsWith('-Apple');

Future<void> main([List<String> args = const []]) async {
  // The `main` entry point into any dart app.
  //
  // This is required to be [async] since we use [await] below to initalise the window manager.
  //
  // The [args] are the command line arguments, as forwarded to the Dart entry
  // point by the platform runners, and support naming a dataset to load on
  // startup, as in `rattle myData.csv`, rather than always having to load the
  // dataset through the DATASET button. The parameter is optional so that the
  // integration tests, which call `app.main()` directly, keep working.
  // (gjw 20260815)

  WidgetsFlutterBinding.ensureInitialized();

  // 20260817 gjw Issue #1179. Report the version, or the usage, and exit,
  // without starting up the app, as any command line program is expected to.
  // Done before anything else, and in particular before the check for R, so
  // that asking Rattle about itself answers the question rather than reporting
  // on R. On Linux these are answered by the runner before we get here, so that
  // no window is created for them.

  if (args.any((arg) => arg.startsWith('-'))) {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String name = info.appName;

    // Help wins when both are asked for, being the more informative answer.

    if (args.contains('--help') || args.contains('-h')) {
      stdout.writeln(usage(name));

      exit(0);
    }

    if (args.contains('--version') || args.contains('-v')) {
      stdout.writeln('$name ${info.version}');

      exit(0);
    }

    // Anything else that looks like an option is a mistake, most likely a typo,
    // and is better reported than quietly ignored while the app starts up as
    // though nothing were wrong.

    for (final String arg in args) {
      if (!arg.startsWith('-') || isLaunchArgument(arg)) continue;

      stderr.writeln("$name: unrecognised option '$arg'");
      stderr.writeln();
      stderr.writeln(usage(name));

      exit(2);
    }
  }

  bool isRInstalled = await checkRInstallation();

  // If R is not installed, show an error and exit the app.

  if (!isRInstalled) {
    runApp(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              Future.delayed(
                Duration.zero,
                () => showError(
                  content: '''

                R is **not installed** or it was not found in the **PATH** environment variable.

                Please install R and ensure it is in the PATH before using Rattle.

                See the

                [survival guide](https://survivor.togaware.com/datascience/installing-rattle.html)

                for details.

                ''',
                  context: context.mounted ? context : exit(0),
                  title: 'R Installation Error',
                  onOkPressed: () {
                    exit(0);
                  },
                ),
              );

              return const Scaffold();
            },
          ),
        ),
      ),
    );

    return;
  }

  // In production do not display [debugPrint] messages.

  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {
      null;
    };
  }

  // TODO: check for updates
  // debugPrint('Current directory: ${p.current}');
  // // retrieve the latest bump version from git commit history
  // if (await GitDir.isGitDir(p.current)) {
  //   final gitDir = await GitDir.fromExisting(p.current);
  //   final commitCount = await gitDir.commitCount();
  //   final commitHistory = await gitDir.commits();

  //   for (var commit in commitHistory.values) {
  //     if (commit.message.toLowerCase().contains('bump version')) {
  //       debugPrint(commit.message);
  //       break;
  //     }
  //   }

  //   debugPrint('Git commit count: $commitCount');
  // } else {
  //   debugPrint('Not a Git directory');
  // }

  // Tune the window manager before runApp() to avoid a lag in the UI.
  //
  // For desktop (non-web) versions re-size to a comfortable initial window.

  if (isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    // The size the window was left at when the app was last used, if we have
    // been remembering it.

    final prefs = await SharedPreferences.getInstance();
    final double? savedWidth = prefs.getDouble(windowWidthPref);
    final double? savedHeight = prefs.getDouble(windowHeightPref);

    WindowOptions windowOptions = WindowOptions(
      // Setting [alwaysOnTop] here will ensure the desktop app starts on top of
      // other apps on the desktop so that it is visible.
      //
      // We later turn it off as we don't want to force it always on top.
      alwaysOnTop: true,

      // 20260817 gjw Open at the size the app was last left at. Until there is
      // one to restore we deliberately pass no size at all, so that each
      // platform keeps the default it sets for itself in its own runner: 1300
      // by 850 in `linux/my_application.cc`, and 1280 by 720 in
      // `windows/runner/main.cpp`, where 950 by 600 was found to be too small.

      size: (savedWidth != null && savedHeight != null)
          ? Size(savedWidth, savedHeight)
          : null,

      // The [title] is used for the window manager's window title.
      title: 'Rattle - Data Science with R',
    );

    // The window should be on top now, so show the window, give it focus, and
    // then turn always on top off.

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  // Initialise a global temporary directory where generated files, such as
  // charts, are saved and can be removed on exit from rattleng or on loading a
  // new dataset.
  //
  // Notice on Windows the path is of the form `C:\AppDir\Users\...` which is
  // not acceptable by R (which requires `\\`) so map them to `/` which is
  // accepted by R on Windows.

  final rattleDir = await Directory.systemTemp.createTemp('rattle');
  tempDir = rattleDir.path.replaceAll(r'\', '/');

  // Set up the app's color scheme.
  Flavor flavor = catppuccin.latte;

  // Identify any dataset named on the command line. We require a recognised
  // dataset file extension so that other arguments are not mistaken for a
  // filename. The launch environment can add arguments of its own, particularly
  // on macOS where Finder passes `-psn_0_...` and Xcode passes
  // `-NSDocumentRevisionsDebugMode YES`, and there that trailing `YES` would
  // otherwise look like a filename and pop up a File Not Found on startup.

  String datasetArg = args.firstWhere(
    (arg) => datasetExtensions.any(
      (ext) => arg.toLowerCase().endsWith('.$ext'),
    ),
    orElse: () => '',
  );

  if (datasetArg.isNotEmpty) datasetArg = resolveDatasetPath(datasetArg);

  // The runApp() function takes the given Widget and makes it the root of the
  // widget tree.
  //
  // Here we wrap the app within RiverPod's ProviderScope() to support state
  // management.
  //
  // We also set up the app's theme through it being a [MaterialApp] and return
  // the [MaterialApp] widget that serves as the root of the app.

  runApp(
    ProviderScope(
      // 20240923 gjw [MaterialApp] was moved here from app.dart on implementing
      // the close dialog, since it needs a MaterialLocalizations to be in the
      // parentage which MaterialApp ensures, and it makes sense for it to be
      // the root.
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // Material 3 is the current (2024) flutter default theme for colours
          // and Google fonts. We can stay with this as the default for now
          // while we experiment with options.
          //
          // We could turn the new material theme off to get the older look.
          //
          // useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(seedColor: flavor.mantle),

          // primarySwatch: createMaterialColor(Colors.black),

          // The default font size seems rather small. So increase it here.
          // textTheme: Theme.of(context).textTheme.apply(
          //       fontSizeFactor: 1.1,
          //       fontSizeDelta: 2.0,
          //     ),
        ),
        home: RattleApp(datasetPath: datasetArg),
      ),
    ),
  );
}
