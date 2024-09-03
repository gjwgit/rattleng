/// Cleanup ignore test on DEMO dataset.
//
// Time-stamp: <Tuesday 2024-08-20 16:43:38 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.
// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// Local imports
import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/main.dart' as app;

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Dataset:', () {
    testWidgets('cleanup tab ignore test', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      // Load DEMO

      final datasetButtonFinder = find.byType(DatasetButton);
      expect(datasetButtonFinder, findsOneWidget);
      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      expect(datasetButton, findsOneWidget);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);

      final demoButton = find.text('Demo');
      expect(demoButton, findsOneWidget);

      await tester.tap(demoButton);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      final dsPathTextFinder = find.byKey(datasetPathKey);
      expect(dsPathTextFinder, findsOneWidget);
      final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
      String filename = dsPathText.controller?.text ?? '';
      expect(filename, 'rattle::weather');

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button twice to go to the last page for variable role selection.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

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
      }

      // Navigate to the "Transform" tab.

      final transformTabFinder = find.text('Transform');
      expect(
        transformTabFinder,
        findsOneWidget,
      );
      await tester.tap(transformTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the "Cleanup" sub-tab within the Transform tab.

      final cleanupSubTabFinder = find.text('Cleanup');
      expect(
        cleanupSubTabFinder,
        findsOneWidget,
      );
      await tester.tap(cleanupSubTabFinder);
      await tester.pumpAndSettle();

      // Locate the "Ignore" chip.

      final ignoreChipFinder = find.text('Ignored');

      expect(
        ignoreChipFinder,
        findsOneWidget,
      );

      await tester.tap(ignoreChipFinder);
      await tester.pumpAndSettle();

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

      // Go to the next page and confirm that the deleted variables are not listed.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Check that deleted variables are not listed on the next page.

      final deletedVariables = ['date', 'min_temp', 'max_temp', 'rainfall'];
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

      final visualSubTabFinder = find.text('Visual');

      // Ensure the "Visual" sub-tab exists.

      expect(
        visualSubTabFinder,
        findsOneWidget,
      );

      // Tap on the "Visual" sub-tab.

      await tester.tap(visualSubTabFinder);
      await tester.pumpAndSettle();

      // Check that 'evaporation' is the selected variable.

      final evaporationSelectedFinder = find.text('evaporation').hitTestable();

      // Ensure 'evaporation' is selected.

      expect(
        evaporationSelectedFinder,
        findsOneWidget,
      );

      // Tap on the dropdown menu.

      await tester.tap(evaporationSelectedFinder);
      await tester.pumpAndSettle();

      // Check that deleted variables are not in the dropdown options.

      for (String variable in deletedVariables) {
        final dropdownOptionFinder = find.text(variable);
        expect(
          dropdownOptionFinder,
          findsNothing,
        );
      }

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

      // Tap the right arrow button twice to go to the variable role selection.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

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
      }

      // Navigate to the "Transform" tab.

      await tester.tap(transformTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the "Cleanup" sub-tab within the Transform tab.

      await tester.tap(cleanupSubTabFinder);
      await tester.pumpAndSettle();

      // Check the ignored chip is selected. Fail the test if not. If it is then simply tap the "Delete from Dataset" button.

      final ignoreChip = find.widgetWithText(ChoiceChip, 'Ignored').evaluate().first.widget as ChoiceChip;
      bool isSelected = ignoreChip.selected;
      if (!isSelected) {
        fail('The "Ignored" chip is not selected, failing the test.');
      }

      // Tap the "Delete from Dataset" button.

      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      // Confirm the deletion by tapping the "Yes" button.

      await tester.tap(
        yesButtonFinder,
      );
      await tester.pumpAndSettle();

      // Navigate to "EXPLORE" -> "VISUAL".

      // Tap on the "Explore" tab.

      await tester.tap(exploreTabFinder);
      await tester.pumpAndSettle();

      // Tap on the "Visual" sub-tab.

      await tester.tap(visualSubTabFinder);
      await tester.pumpAndSettle();

      // Check that 'wind_gust_speed' is the selected variable.

      final windGustSpeedFinder = find.text('wind_gust_speed').hitTestable();
      expect(
        windGustSpeedFinder,
        findsOneWidget,
      );
    });
  });
}
