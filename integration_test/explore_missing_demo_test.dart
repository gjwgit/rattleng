/// EXPLORE tab: Missing Demo Dataset Test.
//
// Time-stamp: <Tuesday 2024-08-20 16:43:07 +1000 Graham Williams>
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
/// Authors:  Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/missing/panel.dart';

import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/tabs/explore.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Tab:', () {
    testWidgets('Demo Dataset, Explore, Missing.', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

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

      // Find the Explore tab by icon and tap on it.

      final exploreIconFinder = find.byIcon(Icons.insights);
      expect(exploreIconFinder, findsOneWidget);

      // Tap the Explore tab.

      await tester.tap(exploreIconFinder);
      await tester.pumpAndSettle();

      // Verify if the ExploreTabs widget is shown.

      expect(find.byType(ExploreTabs), findsOneWidget);

      // Navigate to the Missing tab.

      final exploreTabFinder = find.text('Explore');
      await tester.tap(exploreTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the Missing tab by its title.

      final missingTabFinder = find.text('Missing');
      expect(missingTabFinder, findsOneWidget);

      // Tap the Missing tab.

      await tester.tap(missingTabFinder);
      await tester.pumpAndSettle();

      // Verify that the MissingPanel is shown.

      expect(find.byType(MissingPanel), findsOneWidget);

      await tester.pump(pause);

      // Find the button by its text.

      final generateSummaryButtonFinder = find.text('Perform Missing Analysis');
      expect(generateSummaryButtonFinder, findsOneWidget);

      // Tap the button.

      await tester.tap(generateSummaryButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);
      await tester.pump(delay);

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to "Summary of the Dataset" page 1.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Patterns of Missing Data".

      final title1Finder = find.textContaining('Patterns of Missing Data');
      expect(title1Finder, findsOneWidget);

      // Find the text containing "47".

      final valueFinder = find.textContaining('47');
      expect(valueFinder, findsOneWidget);

      // Tap the right arrow button to go to "Patterns of Missing Values" page 2.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Patterns of Missing Values".

      final titlePage2Finder =
          find.textContaining('Patterns of Missing Values');
      expect(titlePage2Finder, findsOneWidget);

      // Tap the right arrow button to go to "Aggregation of Missing Values - Textual" page 3.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Aggregation of Missing Values - Textual".

      final titlePage3Finder =
          find.textContaining('Aggregation of Missing Values - Textual');
      expect(titlePage3Finder, findsOneWidget);

      // Find the text containing "31" as the wind_dir_9am.

      final windFinder = find.textContaining('31');
      expect(windFinder, findsOneWidget);

      // Tap the right arrow button to go to "Aggregation of Missing Values - Visual" page 4.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Aggregation of Missing Values - Visual".

      final titlePage4Finder =
          find.textContaining('Aggregation of Missing Values - Visual');
      expect(titlePage4Finder, findsOneWidget);

      // Tap the right arrow button to go to "Visualisation of Observations with Missing Values" page 5.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Visualisation of Observations with Missing Values".

      final titlePage5Finder = find
          .textContaining('Visualisation of Observations with Missing Values');
      expect(titlePage5Finder, findsOneWidget);

      // Tap the right arrow button to go to "Comparison of Counts of Missing Values" page 6.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Comparison of Counts of Missing Values".

      final titlePage6Finder =
          find.textContaining('Comparison of Counts of Missing Values');
      expect(titlePage6Finder, findsOneWidget);

      // Tap the right arrow button to go to "Patterns of Missingness" page 7.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Patterns of Missingness".

      final titlePage7Finder = find.textContaining('Patterns of Missingness');
      expect(titlePage7Finder, findsOneWidget);
    });
  });
}
