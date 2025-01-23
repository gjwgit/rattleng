/// LARGE EXPLORE SUMMARY.
//
// Time-stamp: <Thursday 2025-01-23 16:50:04 +1100 Graham Williams>
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Summary.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDatasetByPath(tester, 'integration_test/medical.csv');
    await gotoNextPage(tester);

    await navigateToTab(tester, 'Explore');
    await navigateToFeature(tester, 'Summary', SummaryPanel);
    await tapButton(tester, 'Generate Dataset Summary');

    await tester.pump(hack);

    await gotoNextPage(tester);

    // Find some expected strings.

    final ssnFinder = find.textContaining('Length:20000');
    expect(ssnFinder, findsOneWidget);

    // Find the gender containing count of females".

    final firstNameFinder = find.textContaining('f:12435');
    expect(firstNameFinder, findsOneWidget);

    // Tap the right arrow button to go to "Dataset Glimpse" page.

    await gotoNextPage(tester);

    // Find the text containing "20,000" as the number of rows.

    var rowsFinder = find.textContaining('Rows: 20,000');
    expect(rowsFinder, findsOneWidget);

    // Tap the right arrow button to go to "Skim of the Dataset" page.

    await gotoNextPage(tester);

    // Find the text containing "20000" as the number of rows.

    rowsFinder = find.textContaining('20000');
    expect(rowsFinder, findsOneWidget);

    // Find the text containing "24" as the number of columns.

    final columnsFinder = find.textContaining('24');
    expect(columnsFinder, findsNWidgets(2));

    // Tap the right arrow button to go to "Kurtosis and Skewness" page.

    await gotoNextPage(tester);

    // Find the text containing "2.35753359" as the weight.

    final weightFinder = find.textContaining('2.12090961');
    expect(weightFinder, findsOneWidget);

    // Find the text containing "0.099352734" as the age_at_consultation.

    final ageFinder = find.textContaining('0.099352734');
    expect(ageFinder, findsOneWidget);
  });
}
