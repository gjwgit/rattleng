/// A button to save the script to file.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Time-stamp: <Friday 2023-09-15 06:57:22 +1000 Graham Williams>
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

import 'dart:io' show File;

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rattle/models/rattle_model.dart';

class ScriptSaveButton extends StatelessWidget {
  const ScriptSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RattleModel>(
      builder: (context, rattle, child) {
        return ElevatedButton(
          child: const Text("Export"),
          onPressed: () {
            File('script.R').writeAsString(rattle.script);
          },
        );
      },
    );
  }
}
