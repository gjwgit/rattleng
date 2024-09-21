/// The root widget for the Rattle app.
///
/// Time-stamp: <Sunday 2024-08-25 07:10:02 +0800 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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
/// Authors: Graham Williams, Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/home.dart';
import 'package:rattle/r/start.dart';
import 'package:rattle/widgets/close_dialog.dart';

import 'package:window_manager/window_manager.dart';

// Add a key to reference [RattleHome] to access its method.

final GlobalKey<RattleHomeState> rattleHomeKey = GlobalKey<RattleHomeState>();

/// A widget for the root of the Rattle app encompassing the Rattle home widget.
///
/// This widget manages the application's lifecycle and handles cleanup
/// operations when the app is about to close. It uses [ConsumerStatefulWidget]
/// to interact with Riverpod providers and [WindowListener] to handle
/// window-related events, particularly for desktop platforms.

class RattleApp extends ConsumerStatefulWidget {
  const RattleApp({super.key});

  @override
  ConsumerState<RattleApp> createState() => _RattleAppState();
}

class _RattleAppState extends ConsumerState<RattleApp> with WindowListener {
  
  /// Initializes the state and sets up window management.

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  /// Removes this object as a window listener when the widget is disposed.

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  /// Initializes window management settings.

  void _init() async {

    // Prevent the window from closing by default

    await windowManager.setPreventClose(true);
    setState(() {});
  }

  /// Handles the window close event.
  ///
  /// This method is called when the user attempts to close the window.
  /// It shows a confirmation dialog and performs cleanup if the user confirms.

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      _showCloseConfirmationDialog();
    }
  }

  void _showCloseConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CloseDialog();
      },
    );
  }

  /// Builds the widget tree for the Rattle app.
  ///
  /// This method initializes the R process, sets up the app's theme,
  /// and returns a [MaterialApp] widget that serves as the home of the app.

  @override
  Widget build(BuildContext context) {

    // Initialize the R process
    // 20240809 On Windows this does not get run due to the Console not being
    // ready and not receiving the early input. Delaying until feature/dataset
    // popup.dart seems to work.

    rStart(context, ref);

    // Set up the app's color scheme
    // final ColorScheme colorScheme = ColorScheme.fromSeed(
    //   brightness: MediaQuery.platformBrightnessOf(context),
    //   seedColor: Colors.indigo,
    // );

    Flavor flavor = catppuccin.latte;

    return MaterialApp(

      //      theme: catppuccinTheme(catppuccin.latte),

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

          // seedColor: flavor.text,

        ),

        // primarySwatch: createMaterialColor(Colors.black),
        // The default font size seems rather small. So increase it here.
        // textTheme: Theme.of(context).textTheme.apply(
        //       fontSizeFactor: 1.1,
        //       fontSizeDelta: 2.0,
        //     ),

      ),
      home: RattleHome(key: rattleHomeKey),
    );
  }
}
