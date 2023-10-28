/// Shake, rattle, and roll data science.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2023-10-28 08:26:27 +1100 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/utils/utils.dart';
//import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/rattle_app.dart';

void main() async {
  // The `main` entry point into any dart app.
  //
  // TODO WHY We use async.

  // Use debugPrint() to print trace messages and backtraces in preference to
  // print(). Use print() for human readable messages to the console for errors,
  // like login credentials error. The debugPrint() output is then able to be
  // globally suppressed with the following noop redefinition. We also use an
  // environment through helper/utils.dart to toggle this externally, often
  // through a Makefile. 20220512 gjw

  if (DebugPrintConfig.debugPrint == 'FALSE') {
    debugPrint = (String? message, {int? wrapWidth}) {
      null;
    };
  }

  // Tune the window manager before runApp() to avoid a lag in the UI. For
  // desktop (non-web) versions re-size to a comfortable initial window.

  if (isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      // Setting [alwaysOnTop] here will ensure the app starts on top of other
      // apps on the desktop so that it is visible. We later turn it of as we
      // don;t want to force it always on top.

      alwaysOnTop: true,

      // The size is overridden in the first instance by linux/my_application.cc
      // but setting it here then does have effect when Restarting the app.

      // Windows has 1280x720 by default in windows/runner/main.cpp line 29 so
      // best not to override it here since under windows the 950x600 is too
      // small.

      // size: Size(950, 600),

      // The [title] is used for the window manager's window title.

      title: "RattleNG - Data Science with R",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  // The runApp() function takes the given Widget and makes it the root of the
  // widget tree. Here we wrap the app within a ProviderScope() to support state
  // management.

  runApp(
    const ProviderScope(
      child: RattleApp(),
    ),
  );
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => RattleModel(),
  //     child: const RattleApp(),
  //   ),
  // );
}
