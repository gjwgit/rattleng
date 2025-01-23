/// Verify a variables role on the ROLES page.
//
// Time-stamp: <Friday 2025-01-24 10:34:29 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Kevin Wang

library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> verifyRole(String variable, String role) async {
  // Find the Text widget containing the variable name.

  final variableFinder = find.text(variable).first;

  // Find the parent Row widget that contains both variable name and role chips.

  final parentFinder = find.ancestor(
    of: variableFinder,
    matching: find.byType(Row),
  );

  // Verify that both variable and role exist.

  expect(variableFinder, findsOneWidget);
  // Verify that the role chip exists and is selected.

  final choiceChip = find
      .descendant(
        of: parentFinder.first,
        matching: find.byType(ChoiceChip),
      )
      .evaluate()
      .firstWhere(
        (element) =>
            element.widget is ChoiceChip &&
            (element.widget as ChoiceChip).label is Text &&
            ((element.widget as ChoiceChip).label as Text).data == role &&
            (element.widget as ChoiceChip).selected,
      );
  expect(choiceChip, isNotNull);
}
