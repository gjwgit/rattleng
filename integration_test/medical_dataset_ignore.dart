/// Test the set of high level variables to ignore.
//
// Time-stamp: <Tuesday 2024-10-08 14:42:48 +1100 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/open_dataset_by_path.dart';

/// List of specific variables that should have their role automatically set to
/// 'Ignore' in the DEMO and the LARGE datasets.

final List<String> largeVariablesToIgnore = [
  'rec_id',
  'ssn',
  'first_name',
  'middle_name',
  'last_name',
  'birth_date',
  'medicare_number',
  'street_address',
  'suburb',
  'postcode',
  'phone',
  'email',
  'clinical_notes',
  'consultation_timestamp',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Set Variables to Ignore Test:', () {
    testWidgets('Test large dataset.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDatasetByPath(tester, 'integration_test/medical.csv');

      // TODO 20240910 gjw CONSIDER REMOVING THIS HACK

      await tester.pump(longHack);

      // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);

      // Tap the right arrow button to go to Variable page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      // Find the scrollable ListView.

      final scrollableFinder = find.byKey(const Key('roles_list_view'));

      // Iterate over each variable in the list and find its corresponding row in the ListView.

      for (final variable in largeVariablesToIgnore) {
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
  });
}
