/// Navigate to a specific page counting from 0.
//
// Time-stamp: <Wednesday 2025-02-12 16:27:24 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';

Future<void> navigateToPage(
  WidgetTester tester,
  int page,
  String title,
) async {
  // 20250212 gjw Currently we've not found a way to directly go to a specific
  // page. It should be possible. A work around is to do multiple back clicks to
  // hopefully go to the first page, then a series of forward clicks.

  // Find the back and forward arrow buttons in the PageIndicator.

  final backArrowFinder = find.byIcon(Icons.arrow_left_rounded);
  expect(backArrowFinder, findsOneWidget);

  final fwdArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(backArrowFinder, findsOneWidget);

  // 20250212 gjw Tap the back button 5 times. For most pages that should be okay.

  for (var i = 0; i < 5; i++) {
    await tester.tap(backArrowFinder);
    await tester.pumpAndSettle();
  }

  // Tap the forward button the required number of times.

  for (var i = 0; i < page; i++) {
    await tester.tap(fwdArrowFinder);
    await tester.pumpAndSettle();
  }

  // Pause after screen change.

  await tester.pump(interact);

  // Check for the expected title.

  if (title.length > 0) {
    final titleFinder = find.text(title);
    expect(titleFinder, findsOneWidget);
  }
}
