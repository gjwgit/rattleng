/// Shake, rattle, and roll data science.
///
/// Time-stamp: <Friday 2024-08-02 12:49:08 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/app.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/utils/is_desktop.dart';

// Check if this is a production (--release) version.

const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() async {
  // The `main` entry point into any dart app.
  //
  // This is required to be [async] since we use [await] below to initalise the
  // window manager.

  // In production do not display [debguPrint] messages.

  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // Tune the window manager before runApp() to avoid a lag in the UI. For
  // desktop (non-web) versions re-size to a comfortable initial window.

  if (isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      // Setting [alwaysOnTop] here will ensure the desktop app starts on top of
      // other apps on the desktop so that it is visible. We later turn it of as
      // we don't want to force it always on top.

      alwaysOnTop: true,

      // We can override the size in the first instance by, for example in
      // Linux, editting linux/my_application.cc. Setting it here has effect
      // when Restarting the app whil debugging

      // Hoever, since Windows has 1280x720 by default in the windows-specific
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

  final rattleDir = await Directory.systemTemp.createTemp('rattle');
  tempDir = rattleDir.path.replaceAll(r'\', '/');

  // The runApp() function takes the given Widget and makes it the root of the
  // widget tree. Here we wrap the app within RiverPod's ProviderScope() to
  // support state management.

  runApp(
    const ProviderScope(
      child: RattleApp(),
    ),
  );
}
