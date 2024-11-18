/// Shake, rattle, and roll for the data scientist.
///
/// Time-stamp: <Friday 2024-11-01 09:10:12 +1100 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/app.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/utils/is_desktop.dart';
import 'package:rattle/utils/is_production.dart';

Future<bool> checkRInstallation() async {
  // Try to run the R command to check its availability.

  try {
    final result = await Process.run('R', ['--version']);

    // Check if "R version" is present in the output.

    return result.exitCode == 0;
  } catch (e) {
    // R is not installed or not in PATH.

    return false;
  }
}

void showErrorAndExit(BuildContext context, String message) {
  // Show an error popup if R is not installed and then exit the app.

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => exit(0),
          child: const Text('Exit'),
        ),
      ],
    ),
  );
}

Future<void> main() async {
  // The `main` entry point into any dart app.
  //
  // This is required to be [async] since we use [await] below to initalise the window manager.

  WidgetsFlutterBinding.ensureInitialized();

  bool isRInstalled = await checkRInstallation();

  // If R is not installed, show an error and exit the app.

  if (!isRInstalled) {
    runApp(
      MaterialApp(
        home: Builder(
          builder: (context) {
            Future.delayed(
              Duration.zero,
              () => showErrorAndExit(
                context,
                'R is not installed or not in the system PATH. Please install it before using Rattle.',
              ),
            );

            return Scaffold();
          },
        ),
      ),
    );

    return;
  }
  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: catppuccin.latte.mantle,
              ),
            ),
            home: const RattleApp(),
          );
        },
      ),
    ),
  );

  // In production do not display [debugPrint] messages.

  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {
      null;
    };
  }

  // Tune the window manager before runApp() to avoid a lag in the UI.
  //
  // For desktop (non-web) versions re-size to a comfortable initial window.

  if (isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      // Setting [alwaysOnTop] here will ensure the desktop app starts on top of
      // other apps on the desktop so that it is visible.
      //
      // We later turn it off as we don't want to force it always on top.

      alwaysOnTop: true,

      // We can override the size in the first instance by, for example in
      // Linux, editing linux/my_application.cc.
      //
      // Setting it here has effect when Restarting the app while debugging.

      // However, since Windows has 1280x720 by default in the windows-specific
      // windows/runner/main.cpp, line 29, it is best not to override it here
      // since under Windows 950x600 is too small.

      // size: Size(950, 600),

      // The [title] is used for the window manager's window title.

      title: 'RattleNG - Data Science with R',
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
        theme: ThemeData(
          // Material 3 is the current (2024) flutter default theme for colours
          // and Google fonts. We can stay with this as the default for now
          // while we experiment with options.
          //
          // We could turn the new material theme off to get the older look.
          //
          // useMaterial3: false,

          colorScheme: ColorScheme.fromSeed(
            seedColor: flavor.mantle,
          ),

          // primarySwatch: createMaterialColor(Colors.black),

          // The default font size seems rather small. So increase it here.
          // textTheme: Theme.of(context).textTheme.apply(
          //       fontSizeFactor: 1.1,
          //       fontSizeDelta: 2.0,
          //     ),
        ),
        home: const RattleApp(),
      ),
    ),
  );
}
