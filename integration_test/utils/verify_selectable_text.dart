/// Verify selectable text content in the widget.
//
// Time-stamp: <Tuesday 2025-03-11 07:56:50 +1100 Graham Williams>
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

/// Verify all [texts] present (or not) within SelectableText.
///
/// 1. Find all SelectableText widgets in the widget tree
/// 2. Check each widget's text content to see if it contains [texts]
/// 3. Fails the test if found any [texts] is not [present]
///
/// We needed to define this separately from verifyText because XXXX?

Future<void> verifySelectableText(WidgetTester tester, List<String> texts,
    {bool present = true}) async {
  // Find all SelectableText widgets in the widget tree.

  final textFinder = find.byType(SelectableText);
  expect(textFinder, findsWidgets);

  // Check each required text string.

  for (final text in texts) {
    // Track whether we found this text in any widget.

    bool foundText = false;

    // Iterate through all found SelectableText widgets.

    for (final element in textFinder.evaluate()) {
      final widget = element.widget as SelectableText;
      // Check if widget has non-null text data.

      if (widget.data != null) {
        // Check if widget text contains our search string.

        if (widget.data!.contains(text)) {
          foundText = true;
          break;
        }
      }
    }

    // Fail test if text wasn't found in any widget (when [present] is true) or
    // the text was found in a SelectedableText (when [present] is false).

    expect(
      foundText,
      present,
      reason: present
          ? 'Text "$text" not found in SelectableText.'
          : 'Text "$text" was not expected to be found in SelectableText.',
    );
  }
}
