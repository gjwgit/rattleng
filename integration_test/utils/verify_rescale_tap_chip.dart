/// Verify the Rescale feature on the DEMO dataset.
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

import 'package:flutter_test/flutter_test.dart';
import 'delays.dart';
import 'goto_next_page.dart';
import 'scroll_until_find_key.dart';
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

Future<void> verify_rescale_tap_chip(
  WidgetTester tester,
  String chipText,
  String variableName,
  List<String> expectedStats,
) async {
  // Tap the rescale chip with the specified text.

  await tapChip(tester, chipText);

  await tapButton(tester, 'Rescale Variable Values');
  await tester.pump(delay);
  await gotoNextPage(tester);

  await verifyPage('Dataset Summary', variableName);

  // Scroll to find and verify the statistical summary.

  await scrollUntilFindKey(tester, 'text_page');
  await verifySelectableText(tester, expectedStats);
}
