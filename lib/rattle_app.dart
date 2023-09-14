/// The root widget for the Rattle app.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2023-09-15 05:36:51 +1000 Graham Williams>
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

import 'package:rattle/helpers/create_material_color.dart';
import 'package:rattle/home_page.dart';

/// A widget for the root of the Rattle App.
///
/// The root widget covers the screen of the app. This widget is stateless so
/// that it does not manage any state.

class RattleApp extends StatelessWidget {
  const RattleApp({super.key});

  /// We build the root widget as a MaterialApp() widget, turning off the
  /// default debug corner banner, setting up the app theme, and populating the
  /// widget with the Rattle home page widget.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xff45035e)),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.1,
              fontSizeDelta: 2.0,
            ),
      ),
      home: const HomePage(),
    );
  }
}
