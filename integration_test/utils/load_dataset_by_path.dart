/// Load a dataset from its path.
//
// Time-stamp: <Thursday 2025-01-23 12:27:41 +1100 Graham Williams>
//
/// Copyright (C) 2023-2025, Togaware Pty Ltd
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

Future<void> loadDatasetByPath(
  WidgetTester tester,
  String path,
) async {
  // Locate the TextField where the file path is input.

  final filePathField = find.byType(TextField);
  expect(filePathField, findsOneWidget);

  // Enter the file path programmatically.

  await tester.enterText(filePathField, path);

  // Simulate pressing the Enter key.

  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  // Additional delay to load the dataset.

  await tester.pump(delay);
}
