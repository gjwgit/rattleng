/// Open the a dataset from its path
//
// Time-stamp: <Friday 2024-09-20 08:07:17 +1000 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';

Future<void> openDatasetByPath(WidgetTester tester, String path) async {
  // Locate the TextField where the file path is input.

  final filePathField = find.byType(TextField);
  expect(filePathField, findsOneWidget);

  // Enter the file path programmatically.

  await tester.enterText(
    filePathField,
    path,
  );

  // Simulate pressing the Enter key.

  await tester.testTextInput.receiveAction(TextInputAction.done);

  // Optionally pump the widget tree to reflect the changes.

  await tester.pumpAndSettle();

  await tester.pump(pause);

  // TODO 20240903 zy WE NEED TO ELIMINATE THE hack WAIT DUE TO async.

  await tester.pump(hack);
}
