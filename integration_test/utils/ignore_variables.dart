/// Support for ignoring variables on the ROLEs page.
//
// Time-stamp: <Sunday 2024-10-20 17:28:36 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';
import 'test_print.dart';

Future ignoreVariables(
  WidgetTester tester,
  List<String> vars,
) async {
  // Expect to find the scrollable ListView - ROLES.

  final scrollableFinder = find.byKey(const Key('roles_list_view'));
  expect(scrollableFinder, findsOneWidget);

  testPrint('Found the ROLES page to IGNORE variables.');

  for (final v in vars) {
    bool foundVar = false;

    // Scroll in steps and search for the variable until it's found.

    while (!foundVar) {
      // Find the row where the variable name is displayed.

      final varFinder = find.text(v);

      if (tester.any(varFinder)) {
        foundVar = true;

        // Find the parent widget that contains the variable and its associated ChoiceChip.

        final parentFinder = find.ancestor(
          of: varFinder,
          matching: find.byType(
            Row,
          ),
        );

        // Select the first Row in the list.

        final firstRowFinder = parentFinder.first;

        // Tap the correct ChoiceChip to change the role to 'Ignore'.

        final ignoreChipFinder = find.descendant(
          of: firstRowFinder,
          matching: find.text('Ignore'),
        );

        await tester.tap(ignoreChipFinder);
        await tester.pumpAndSettle();

        // Verify that the role is now set to 'Ignore'.

        expect(ignoreChipFinder, findsOneWidget);
      } else {
        final currentScrollableFinder = scrollableFinder.first;

        // Fling (or swipe) down by a small amount.

        await tester.fling(
          currentScrollableFinder,
          const Offset(0, -300), // Scroll down
          1000,
        );
        await tester.pumpAndSettle();
        await tester.pump(delay);

        // Tab the previous variable to avoid missing tab it.
        // Missing tab happens if Ignore button overlaps the rightArrow icon.

        int index = vars.indexOf(v);
        if (index > 0) {
          String preVar = vars[index - 1];

          // Find the row where the variable name is displayed.

          final preVarFinder = find.text(preVar);

          if (tester.any(preVarFinder)) {
            // Find the parent widget that contains the variable and its associated ChoiceChip.

            final preParentFinder = find.ancestor(
              of: preVarFinder,
              matching: find.byType(
                Row,
              ),
            );

            // Select the first Row in the list.

            final firstRowFinder = preParentFinder.first;

            // Tap the correct ChoiceChip to change the role to 'Ignore'.

            final ignoreChipFinder = find.descendant(
              of: firstRowFinder,
              matching: find.text('Ignore'),
            );

            await tester.tap(ignoreChipFinder);

            await tester.pumpAndSettle();

            // Verify that the role is now set to 'Ignore'.

            expect(ignoreChipFinder, findsOneWidget);
          }
        }
      }
    }
  }
  testPrint('Finished IGNORE variables.');
}
