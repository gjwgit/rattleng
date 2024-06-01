/// The root widget for the Rattle app.
///
/// Time-stamp: <Sunday 2024-06-02 09:15:58 +1000 Graham Williams>
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
/// Authors: Graham Williams

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/home.dart';
import 'package:rattle/r/start.dart';
import 'package:rattle/utils/create_material_color.dart';

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

    rStart(ref);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: createMaterialColor(headerBarColour),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.1,
              fontSizeDelta: 2.0,
            ),
      ),
      home: const RattleHome(),
    );
  }
}
