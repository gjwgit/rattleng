/// WEATHER dataset EXPLORE tab SUMARY feature.
///
// Time-stamp: <Thursday 2025-01-30 14:32:19 +1100 Graham Williams>
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER EXPLORE SUMMARY:', () {
    testWidgets('.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester);
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Summary', SummaryPanel);
      await tapButton(tester, 'Generate Dataset Summary');
      await tester.pump(hack);
      await gotoNextPage(tester);
      await verifySelectableText(
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
      await gotoNextPage(tester); // Datset Glimpse
      await gotoNextPage(tester); // Skime the Dataset

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
      await gotoNextPage(tester); // Kurtosis and Skewness

      // Find the text containing the min_temp.

      final tempMinFinder = find.textContaining('-1.0832020');
      expect(tempMinFinder, findsOneWidget);

      // Find the text containing "-1.0649102" as the max_temp.

      final tempMaxFinder = find.textContaining('-1.0649102');
      expect(tempMaxFinder, findsOneWidget);
    });
  });
}
