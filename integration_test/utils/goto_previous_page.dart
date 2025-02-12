/// Move to the previous age.
//
// Time-stamp: <Wednesday 2025-02-12 16:05:46 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';

Future<void> gotoPreviousPage(WidgetTester tester) async {
  // Find the right arrow button in the PageIndicator.

  final backArrowFinder = find.byIcon(Icons.arrow_left_rounded);
  expect(backArrowFinder, findsOneWidget);

  // Tap the right arrow button twice to go to the last page for variable role selection.

  await tester.tap(backArrowFinder);
  await tester.pumpAndSettle();

  // Pause after screen change.

  await tester.pump(interact);
}
