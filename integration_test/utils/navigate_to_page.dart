/// Navigate to a specific page counting from 0.
//
// Time-stamp: <Monday 2025-03-24 11:21:37 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';
import 'goto_page.dart';

/// Tap back button [back] times then fwd [page] times and verify [title].

Future<void> navigateToPage(
  WidgetTester tester,
  int page, {
  // Eventually the default back will be 0 rather than 5, and so the exceptions
  // are specificed rather than the usual case which will be that we stay on
  // page 0 (maybe). (gjw 20250324)
  int back = 5,
  String title = '',
}) async {
  // 20250212 gjw Currently we've not found a way to directly go to a specific
  // page. It should be possible. A work around is to do multiple back clicks to
  // hopefully go to the first page, then a series of forward clicks.

  // Find the back and forward arrow buttons in the PageIndicator.

  final backArrowFinder = find.byIcon(Icons.arrow_left_rounded);
  expect(backArrowFinder, findsOneWidget);

  final fwdArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(backArrowFinder, findsOneWidget);

  // 20250212 gjw Tap the back button 5 times. For most pages that should be okay.

  for (var i = 0; i < back; i++) {
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
  //
  // 20260819 gjw Where the caller named the page, make sure that is the page we
  // are on, and go and find it by name if not. Counting arrow taps assumes we
  // knew which page we started from, and a panel that has just rebuilt after an
  // R run can be showing a different page to the one the arrows think it is on.
  // See `utils/goto_page.dart`.

  if (title.isNotEmpty) {
    await gotoPage(tester, title);
  }
}
