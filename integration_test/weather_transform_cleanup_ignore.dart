/// Test TRANSFORM tab CLEANUP feature IGNORE option on the DEMO dataset.
//
// Time-stamp: <Wednesday 2024-10-09 17:27:17 +1100 Graham Williams>
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
/// Authors: Yixiang Yin, Kevin Wang

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/check_popup.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TRANSFORM CLEANUP IGNORE DEMO:', () {
    testWidgets('cleanup', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDemoDataset(tester);

      final dsPathTextFinder = find.byKey(datasetPathKey);
      expect(dsPathTextFinder, findsOneWidget);

      final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
      String filename = dsPathText.controller?.text ?? '';
      expect(filename.contains('weather.csv'), isTrue);

      // await gotoNextPage(tester);

      // Find the "Ignore" buttons and click the first four.

      final buttonFinder = find.text('Ignore');

      // Check that "Ignore" buttons exist

      expect(
        buttonFinder,
        findsWidgets,
      );

      for (int i = 0; i < 4; i++) {
        await tester.tap(buttonFinder.at(i));
        await tester.pumpAndSettle();

        // Pause after screen change.

        await tester.pump(interact);
      }

      // Navigate to the "Transform" tab.

      final transformTabFinder = find.text('Transform');
      expect(
        transformTabFinder,
        findsOneWidget,
      );
      await tester.tap(transformTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Navigate to the "Cleanup" sub-tab within the Transform tab.

      final cleanupSubTabFinder = find.text('Cleanup');
      expect(
        cleanupSubTabFinder,
        findsOneWidget,
      );
      await tester.tap(cleanupSubTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Locate the "Ignore" chip.

      final ignoreChipFinder = find.text('Ignored');

      expect(
        ignoreChipFinder,
        findsOneWidget,
      );

      await tester.tap(ignoreChipFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Tap the "Delete from Dataset" button.

      final deleteButtonFinder = find.text('Delete from Dataset');

      // Ensure the "Delete from Dataset" button exists.

      expect(
        deleteButtonFinder,
        findsOneWidget,
      );

      // Tap on the "Delete from Dataset" button.

      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Check that the variables to be deleted are mentioned in the popup.

      final deletedVariables = ['date', 'min_temp', 'max_temp', 'rainfall'];

      checkInPopup(deletedVariables);

      // Pause after screen change.

      await tester.pump(interact);

      // Confirm the deletion by tapping the "Yes" button.

      final yesButtonFinder = find.text('Yes');

      // Ensure the "Yes" button exists.

      expect(
        yesButtonFinder,
        findsOneWidget,
      );

      // Tap on the "Yes" button to confirm the deletion.

      await tester.tap(
        yesButtonFinder,
      );
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Go to the next page and confirm that the deleted variables are not
      // listed.

      await gotoNextPage(tester);

      // Check that deleted variables are not listed on the next page.

      for (String variable in deletedVariables) {
        final deletedVariableFinder = find.text(variable);

        // Ensure the deleted variable is not listed.

        expect(
          deletedVariableFinder,
          findsNothing,
        );
      }

      // Navigate to "EXPLORE" -> "VISUAL".

      final exploreTabFinder = find.text('Explore');

      // Ensure the "Explore" tab exists.

      expect(
        exploreTabFinder,
        findsOneWidget,
      );

      // Tap on the "Explore" tab.

      await tester.tap(exploreTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      final visualSubTabFinder = find.text('Visual');

      // Ensure the "Visual" sub-tab exists.

      expect(
        visualSubTabFinder,
        findsOneWidget,
      );

      // Tap on the "Visual" sub-tab.

      await tester.tap(visualSubTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Check that 'wind_gust_dir' is the selected variable.

      final evaporationSelectedFinder =
          find.text('wind_gust_dir').hitTestable();

      // Ensure 'wind_gust_dir' is selected.

      expect(
        evaporationSelectedFinder,
        findsOneWidget,
      );

      // Tap on the dropdown menu.

      await tester.tap(evaporationSelectedFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Navigate to the "Dataset" tab.

      final datasetTabFinder = find.text(
        'Dataset',
      );

      // Ensure the "Dataset" tab exists.

      expect(
        datasetTabFinder,
        findsOneWidget,
      );

      // Tap on the "Dataset" tab.

      await tester.tap(datasetTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Tap the right arrow button twice to go to the variable role selection.

      await gotoNextPage(tester);

      // Find the "Ignore" buttons

      final button2Finder = find.text('Ignore');

      // Check "Ignore" button exists

      expect(
        button2Finder,
        findsWidgets,
      );

      // Tap the first two "Ignore" buttons found

      for (int i = 0; i < 2; i++) {
        await tester.tap(button2Finder.at(i));
        await tester.pumpAndSettle();

        // Pause after screen change.

        await tester.pump(interact);
      }

      // Navigate to the "Transform" tab.

      await tester.tap(transformTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Navigate to the "Cleanup" sub-tab within the Transform tab.

      await tester.tap(cleanupSubTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Check the ignored chip is selected. Fail the test if not. If it is then simply tap the "Delete from Dataset" button.

      final ignoreChip = find
          .widgetWithText(ChoiceChip, 'Ignored')
          .evaluate()
          .first
          .widget as ChoiceChip;
      bool isSelected = ignoreChip.selected;
      if (!isSelected) {
        fail('The "Ignored" chip is not selected, failing the test.');
      }

      // Tap the "Delete from Dataset" button.

      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Check that the variables to be deleted are mentioned in the popup.

      checkInPopup(['wind_gust_dir', 'wind_gust_speed']);

      // Pause after screen change.

      await tester.pump(interact);

      // Confirm the deletion by tapping the "Yes" button.

      await tester.tap(
        yesButtonFinder,
      );
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Navigate to "EXPLORE" -> "VISUAL".

      // Tap on the "Explore" tab.

      await tester.tap(exploreTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);
      await tester.pump(hack);

      // Tap on the "Visual" sub-tab.

      await tester.tap(visualSubTabFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Check that 'wind_speed_9am' is the selected variable.

      final windGustSpeedFinder = find.text('wind_speed_9am').hitTestable();
      expect(
        windGustSpeedFinder,
        findsOneWidget,
      );
    });
  });
}
