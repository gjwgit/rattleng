/// The root widget for the Rattle app.
///
/// Time-stamp: <Saturday 2024-08-24 12:09:06 +1000 Graham Williams>
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

// Add a key to reference [RattleHome] to access its method.

final GlobalKey<RattleHomeState> rattleHomeKey = GlobalKey<RattleHomeState>();

/// A widget for the root of the Rattle app encompassing the Rattle home widget.
///
/// The root widget covers the screen of the app. This widget is stateless as it
/// does not need to manage any state itself. The state is managed through
/// riverpod and so it is a [ConsumerWidget].

class RattleApp extends ConsumerWidget {
  const RattleApp({super.key});

  /// Build the root widget as a [MaterialApp] widget, setting up the app theme,
  /// and populating the widget with the Rattle home page widget.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise the R process.

    // 20240809 On Windows this does not get run - that is main.R is not in the
    // Console. Delaying until feature/dataset/popup.dart seems to work. Moving
    // main.R into dataset_prep.R delays the setup too much.
    //
    // 20240810 Revert to this for now and try to solve the Windows issue. Is it
    // because my Windows are too slow and this starts before the Console is
    // running?

    rStart(context, ref);

    // EXPERIMENT with the color scheme.

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
        //
        // EXPERIMENTATION
        //
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
      home: RattleHome(key: rattleHomeKey),
    );
  }
}
