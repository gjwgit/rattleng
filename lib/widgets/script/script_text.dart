/// A SCRIPT text widget for the SCRIPT tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-09-17 08:36:03 +1000 Graham Williams>
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

import 'package:provider/provider.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/widgets.dart';
import 'package:rattle/models/rattle_model.dart';

/// Create a script text viewer that can scroll the text of the script widget.
///
/// The contents is intialised from the main.R script asset.

class ScriptText extends StatelessWidget {
  const ScriptText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return Consumer<RattleModel>(
            // Build a [Consumer] of the [RattleModel] so we can access updated values
            // of the script as it grows.

            builder: (context, rattle, child) {
              // The builder takes a context, a RattleMode, and the child. It is the
              // `rattle` that contains the state that we can access here.

              return SelectableText(
                rattle.script,
                key: scriptTextKey,
                style: monoTextStyle,
              );
            },
          );
        },
      ),
    );
  }
}
