/// Add toggles to the debug page to select what we look at.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-10-16 05:32:29 +1100 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/features/debug/rattle_model_text.dart';
import 'package:rattle/features/debug/stderr_text.dart';
import 'package:rattle/features/debug/stdout_text.dart';

class DebugToggles extends StatefulWidget {
  const DebugToggles({super.key});

  @override
  State<DebugToggles> createState() => _DebugTogglesState();
}

class _DebugTogglesState extends State<DebugToggles> {
  int _selectedToggleIndex = 0;

  // Define widgets for each toggle option.

  final List<Widget> _toggleWidgets = [
    const RattleModelText(),
    const StdoutText(),
    const StderrText(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              isSelected:
                  List.generate(3, (index) => index == _selectedToggleIndex),
              onPressed: (int newIndex) {
                setState(() {
                  _selectedToggleIndex = newIndex;
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: statusBarColour,
              selectedColor: Colors.white,
              fillColor: headerBarColour,
              color: Colors.grey, //red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 200.0,
              ),
              children: const [
                Text('Rattle State'),
                Text('R Standard Output'),
                Text('R Standard Error'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  // Display selected widget

                  Visibility(
                    visible: _selectedToggleIndex == 0,
                    child: _toggleWidgets.first,
                  ),

                  Visibility(
                    visible: _selectedToggleIndex == 1,
                    child: _toggleWidgets[1],
                  ),

                  Visibility(
                    visible: _selectedToggleIndex == 2,
                    child: _toggleWidgets[2],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
