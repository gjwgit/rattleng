/// Shake, rattle, and roll data science.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2023-08-22 09:27:02 +1000 Graham Williams>
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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:universal_io/io.dart' show Platform;
import 'package:window_manager/window_manager.dart';

import 'package:rattle/pages/tabs_page.dart';
import 'package:rattle/widgets/material_color.dart';

void main() async {
  // Identify if Desktop or Mobile app.

  bool isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  // Tune the window manager before runApp to avoid a lag in the UI. For desktop
  // (non-web) versions re-size to mimic mobile (as the main target platform).

  if (isDesktop && !kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      alwaysOnTop: true,
      // The size is overriden in the first instance by linux/my_application.cc
      // but then does has effect when Retarting the app.
      size: Size(950, 600),
      title: "RattleNG - Data Science with R",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  runApp(const RattleApp());
}

class RattleApp extends StatelessWidget {
  const RattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rattling Data for Scientist',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xff45035e)),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.1,
              fontSizeDelta: 2.0,
            ),
      ),
      home: const Tabs(),
    );
  }
}
