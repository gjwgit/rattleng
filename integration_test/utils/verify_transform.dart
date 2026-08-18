/// Verify the Rescale feature on the DEMO dataset.
//
// Time-stamp: <Tuesday 2025-04-22 06:20:21 +1000 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';

import 'navigate_to_page.dart';
import 'tap_button.dart';
import 'tap_chip.dart';
import 'verify_page.dart';
import 'verify_selectable_text.dart';

/// Verify the rescaling of a variable by tapping a chip and checking the results.
///
/// This function performs the following steps:
/// 1. Taps the specified rescale chip (e.g. "Scale [0-1]", "Natural Log")
/// 2. Clicks the "Rescale Variable Values" button
/// 3. Verifies the resulting dataset summary page shows the expected variable name
/// 4. Verifies the statistical summary matches the expected values

Future<void> verifyTransform(
  WidgetTester tester,
  String chipText,
  String buttonName,
  String variableName,
  List<String> expectedStats,
) async {
  // Tap the rescale chip with the specified text.

  await tapChip(tester, chipText);

  await tapButton(tester, buttonName);
  await navigateToPage(tester, 1, back: 2, title: 'Dataset Summary');
  await verifyPage('Dataset Summary', variableName);

  // Verify the statistical summary.
  //
  // 20260818 gjw No scrolling first. `verifySelectableText()` reads the text
  // from the widget, which holds all of it whether or not it is on screen, so
  // scrolling proved nothing. It scrolled to a `PageStorageKey('text_page')`
  // that `widgets/text_page.dart` no longer sets, having been the one key
  // shared by every text page, and scrolling to a key that is not there threw
  // "Bad state: No element".

  await verifySelectableText(tester, expectedStats);
}
