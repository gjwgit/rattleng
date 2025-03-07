/// Verify the state of a labelled checkbox widget.
//
// Time-stamp: <Friday 2025-03-07 08:42:29 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/widgets/labelled_checkbox.dart';

Future<void> verifyCheckbox(
  WidgetTester tester,
  String text,
  bool active,
) async {
  // Find the checkbox widget with the given label text.

  final checkboxFinder = find.widgetWithText(LabelledCheckbox, text);

  // Verify that the checkbox is found.

  expect(checkboxFinder, findsOneWidget);

  // Retrieve the CheckboxListTile widget.

  final LabelledCheckbox checkbox =
      tester.widget<LabelledCheckbox>(checkboxFinder);

  // Verify the active state of the checkbox.

  expect(checkbox.enabled, active);
}
