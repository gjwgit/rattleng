/// Function goes to the DATASET tab and then the ROLES page and
/// sets the given ROLE for the given VARIABLE.
//
// Time-stamp: <Saturday 2024-12-28 06:23:43 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

/// Checks if the widget located by [widgetFinder] is fully within the viewport
/// of the scrollable located by [scrollableFinder].

bool isFullyVisibleInViewport(
  WidgetTester tester,
  Finder widgetFinder,
  Finder scrollableFinder,
) {
  // Get the Rect for the target widget.

  final widgetRect = tester.getRect(widgetFinder);

  // Get the Rect for the scrollable's viewport.
  // Usually the scrollable is a ListView, SingleChildScrollView, etc.

  final scrollableRect = tester.getRect(scrollableFinder);

  // Return true only if the entire widgetRect is contained within scrollableRect.

  return scrollableRect.contains(Offset(widgetRect.left, widgetRect.top)) &&
      scrollableRect.contains(Offset(widgetRect.right, widgetRect.bottom));
}

/// Ensures that [widgetFinder] is physically in the visible area of the scrollable
/// identified by [scrollableFinder]. If not, it calls [tester.dragUntilVisible]
/// once to bring it into view, then pumps and settles.

Future<void> scrollWidgetIntoViewIfNeeded(
  WidgetTester tester,
  Finder widgetFinder,
  Finder scrollableFinder,
) async {
  // If the target widget isn't fully visible, scroll once.

  if (!isFullyVisibleInViewport(tester, widgetFinder, scrollableFinder)) {
    await tester.dragUntilVisible(
      widgetFinder, // the Finder we want to make visible
      scrollableFinder, // the scrollable widget
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
  }
}

/// Locates the variable row [variable] (e.g., "min_temp"),
/// makes sure it's physically visible on screen, then taps
/// the ChoiceChip labeled [role] (e.g., "Ignore").

Future<void> setDatasetRole(
  WidgetTester tester,
  String variable,
  String role,
) async {
  // Wait for initial animations/layout.

  await tester.pumpAndSettle();

  // 1) Find the scrollable list containing variables. Adjust the key as needed.

  final scrollableFinder = find.byKey(const Key('roles listView'));

  // 2) Finder for the variable's text (e.g., "min_temp").

  final variableNameFinder = find.text(variable);

  // 3) Ensure the variable row is actually *in the viewport*.
  //    Even if the widget exists in the tree, it may be off-screen.

  await scrollWidgetIntoViewIfNeeded(
    tester,
    variableNameFinder,
    scrollableFinder,
  );

  // Now we expect that the variable's text is physically visible.

  expect(
    variableNameFinder,
    findsOneWidget,
    reason:
        'Could not find the row for variable "$variable" even after scrolling.',
  );

  // 4) Locate the container with the role chips for this variable.
  //    We assume the code has key: Key('role-$variable') in _buildRoleChips.

  final chipsKey = Key('role-$variable');
  final roleChipsFinder = find.byKey(chipsKey);

  // Also ensure the chips container is visible in the viewport if needed.

  await scrollWidgetIntoViewIfNeeded(
    tester,
    roleChipsFinder,
    scrollableFinder,
  );

  expect(
    roleChipsFinder,
    findsOneWidget,
    reason: 'Could not find the chips container for variable "$variable".',
  );

  // 5) Within the chips container, find the chip with text [role].

  final roleChipFinder = find.descendant(
    of: roleChipsFinder,
    matching: find.text(role),
  );

  // Potentially scroll again if the chip is off-screen horizontally or further down.

  await scrollWidgetIntoViewIfNeeded(
    tester,
    roleChipFinder,
    scrollableFinder,
  );

  // Ensure the role chip is found and visible.

  expect(
    roleChipFinder,
    findsOneWidget,
    reason: 'Could not find role "$role" chip in row for variable "$variable".',
  );

  // 6) Tap the ChoiceChip to select the role.

  await tester.tap(roleChipFinder);
  await tester.pumpAndSettle();
}
