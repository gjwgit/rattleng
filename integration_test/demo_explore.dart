/// Explore tab Demo dataset.
//
// Time-stamp: <Saturday 2024-10-19 11:03:48 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/explore.dart';

import 'utils/delays.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Explore:', () {
    testWidgets('Summary.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDemoDataset(tester);

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

      await tester.pump(interact);

      await verifyText(
        tester,
        [
          // Verify date in the Content Column.
          '2023-07-01',

          // Verify min_temp as second parameter.
          '-6.200',

          // Verify max_temp as third parameter.
          '8.40',
        ],
      );

      // Tap the right arrow button to go to "Dataset Glimpse" page.

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Tap the right arrow button to go to "Skim of the Dataset" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the text containing "365" as the number of rows. 20241019 gjw
      // There should now be two of them, one in the DISPLAY and now another in
      // the STATUS BAR.

      final rowsFinder = find.textContaining('365');
      expect(rowsFinder, findsNWidgets(2));

      // Find the text containing "21" as the number of columns. 20241019 gjw
      // There should now be two of them, one in the DISPLAY and now another in
      // the STATUS BAR.

      final columnsFinder = find.textContaining('21');
      expect(columnsFinder, findsNWidgets(2));

      // Tap the right arrow button to go to "Kurtosis and Skewness" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the text containing the min_temp.

      final tempMinFinder = find.textContaining('-1.0832020');
      expect(tempMinFinder, findsOneWidget);

      // Find the text containing "-1.0649102" as the max_temp.

      final tempMaxFinder = find.textContaining('-1.0649102');
      expect(tempMaxFinder, findsOneWidget);
    });
  });
}
