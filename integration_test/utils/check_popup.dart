/// Check if some variable names are in the popup window.
//
// Time-stamp: <Thursday 2024-06-06 05:58:50 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void checkInPopup(List<String> vars) {
  
  // Locate the popup.

  final popupFinder = find.byType(
    AlertDialog,
  );

  // Ensure the popup is present.

  expect(popupFinder, findsOneWidget);

  // Check that each variable is mentioned in the popup.

  for (String variable in vars) {
    final variableTextFinder = find.descendant(
      of: popupFinder,
      matching: find.textContaining(
        variable,
      ),
    );

    expect(
      variableTextFinder,
      findsOneWidget,
      reason:
          'The variable "$variable" should be mentioned in the popup, but it was not found.',
    );
  }
}
