/// Test WEATHER dataset IGNORE roles.
//
// Time-stamp: <Friday 2024-12-27 15:41:03 +1100 Graham Williams>
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
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/open_weather_dataset.dart';
import 'utils/test_print.dart';

// List of specific variables that should have their role automatically set by
// the app on loading the data to be 'Ignore'. For the DEMO dataset there are no
// IGNORED by default.

final List<String> demoVariablesToIgnore = [];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Weather Ignored.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await openWeatherDataset(tester);

    // Find the scrollable ListView that makes up the ROLES page. This should
    // now be the visible page.

    final scrollableFinder = find.byKey(const Key('roles_list_view'));

    // Iterate over each variable in the list and find its corresponding row in the ListView.

    testPrint('Check for IGNORED variables.');

    for (final variable in demoVariablesToIgnore) {
      bool foundVariable = false;

      // Scroll in steps and search for the variable until it's found.

      while (!foundVariable) {
        // Find the row where the variable name is displayed.

        final variableFinder = find.text(variable);

        if (tester.any(variableFinder)) {
          foundVariable = true;

          // Find the parent widget that contains the variable and its associated ChoiceChip.

          final parentFinder = find.ancestor(
            of: variableFinder,
            matching: find.byType(
              Row,
            ),
          );

          // Select the first Row in the list.

          final firstRowFinder = parentFinder.first;

          // Find the 'Ignore' ChoiceChip within this row.

          final ignoreChipFinder = find.descendant(
            of: firstRowFinder,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is ChoiceChip &&
                  widget.label is Text &&
                  (widget.label as Text).data == 'Ignore',
            ),
          );

          // Verify that the role is now set to 'Ignore'.

          expect(ignoreChipFinder, findsOneWidget);

          // Get the ChoiceChip widget.

          final ChoiceChip ignoreChipWidget =
              tester.widget<ChoiceChip>(ignoreChipFinder);

          // Check if the 'Ignore' ChoiceChip is selected.

          expect(
            ignoreChipWidget.selected,
            isTrue,
            reason: 'Variable $variable should be set to Ignore',
          );
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
        }
      }
    }

    await tester.pumpAndSettle();
    await tester.pump(hack);
  });
}
