/// LARGE EXPLORE SUMMARY.
//
// Time-stamp: <Monday 2024-09-16 14:58:52 +1000 Graham Williams>
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
/// Authors: Graham Williams, Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/explore.dart';

import 'utils/delays.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore large:', () {
    testWidgets('Summary.', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(interact);

      // Locate the TextField where the file path is input.

      final filePathField = find.byType(TextField);
      expect(filePathField, findsOneWidget);

      // Enter the file path programmatically.

      await tester.enterText(
        filePathField,
        'integration_test/medical.csv',
      );

      // Simulate pressing the Enter key.

      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Optionally pump the widget tree to reflect the changes.
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the Explore tab by icon and tap on it.

      final exploreIconFinder = find.byIcon(Icons.insights);
      expect(exploreIconFinder, findsOneWidget);

      // Tap the Explore tab.

      await tester.tap(exploreIconFinder);
      await tester.pumpAndSettle();

      // Verify if the ExploreTabs widget is shown.

      expect(find.byType(ExploreTabs), findsOneWidget);

      // Navigate to the Explore tab.

      final exploreTabFinder = find.text('Explore');
      await tester.tap(exploreTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the Summary tab by its title.

      final summaryTabFinder = find.text('Summary');
      expect(summaryTabFinder, findsOneWidget);

      // Tap the Summary tab.

      await tester.tap(summaryTabFinder);
      await tester.pumpAndSettle();

      // Verify that the SummaryPanel is shown.

      expect(find.byType(SummaryPanel), findsOneWidget);

      await tester.pump(interact);

      // Find the button by its text.

      final generateSummaryButtonFinder = find.text('Generate Dataset Summary');
      expect(generateSummaryButtonFinder, findsOneWidget);

      // Tap the button.

      await tester.tap(generateSummaryButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Add a delay to allow the summary to be generated. This will fix the qtest failure.

      await tester.pump(delay);

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to "Summary of the Dataset" page.

      // await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      await tester.pump(hack);

      // Find some expected strings.

      final ssnFinder = find.textContaining('Length:20000');
      expect(ssnFinder, findsOneWidget);

      // Find the gender containing count of females".

      final firstNameFinder = find.textContaining('f:12435');
      expect(firstNameFinder, findsOneWidget);

      // Tap the right arrow button to go to "Dataset Glimpse" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the text containing "20,000" as the number of rows.

      var rowsFinder = find.textContaining('20,000');
      expect(rowsFinder, findsOneWidget);

      // Tap the right arrow button to go to "Skim of the Dataset" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the text containing "20000" as the number of rows.

      rowsFinder = find.textContaining('20000');
      expect(rowsFinder, findsOneWidget);

      // Find the text containing "24" as the number of columns.

      final columnsFinder = find.textContaining('24');
      expect(columnsFinder, findsOneWidget);

      // Tap the right arrow button to go to "Kurtosis and Skewness" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the text containing "2.35753359" as the weight.

      final weightFinder = find.textContaining('2.12090961');
      expect(weightFinder, findsOneWidget);

      // Find the text containing "0.099352734" as the age_at_consultation.

      final ageFinder = find.textContaining('0.099352734');
      expect(ageFinder, findsOneWidget);
    });
  });
}
