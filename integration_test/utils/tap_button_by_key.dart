/// Tap the button with the given key and fail if multiple keys are found.
///
// Time-stamp: <Thursday 2025-01-30 08:47:17 +1100 Graham Williams>
///
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

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

Future<void> tapButtonByKey(
  WidgetTester tester,
  String key,
) async {
  final button = find.byKey(Key(key));

  // 20250130 gjw Fail if more than a single widget with the key is found. Is
  // that possible or are keys unique across the app?

  expect(button, findsOneWidget);
  await tester.tap(button);
  await tester.pumpAndSettle();
}
