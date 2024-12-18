/// Script tab for home page where the R script is captured.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-06-14 13:57:35 +1000 Graham Williams>
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
library;

import 'package:flutter/material.dart';

import 'package:rattle/tabs/script/info.dart';
import 'package:rattle/tabs/script/text.dart';

// TESTING CAN BE REMOVED? final scriptController = TextEditingController();

class ScriptTab extends StatelessWidget {
  const ScriptTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 4,
          child: Align(
            // Align to the top.

            alignment: Alignment.topCenter,
            child: ScriptInfo(),
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 7,
          child: ScriptText(),
        ),
      ],
    );
  }
}
