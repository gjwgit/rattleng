/// Move to the next page and optionally check the title.
//
// Time-stamp: <Wednesday 2025-03-05 14:46:38 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';
import 'goto_page.dart';

/// Move to the next page and optionally check the [title].

Future<void> gotoNextPage(WidgetTester tester, {String? title}) async {
  // Find the right arrow button in the PageIndicator.

  final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(rightArrowFinder, findsOneWidget);

  // Tap the right arrow button.

  await tester.tap(rightArrowFinder);
  await tester.pumpAndSettle();

  // Pause after screen change.

  await tester.pump(interact);

  // Check for the expected title.
  //
  // 20260819 gjw Where the caller named the page, make sure that is the page we
  // are on, and go and find it by name if not. Counting arrow taps assumes we
  // knew which page we started from, and a panel that has just rebuilt after an
  // R run can be showing a different page to the one the arrows think it is on.
  // See `utils/goto_page.dart`.

  if (title != null && title.isNotEmpty) {
    await gotoPage(tester, title);
  }
}
