/// LARGE EXPLORE SUMMARY.
//
// Time-stamp: <Wednesday 2025-03-05 14:24:54 +1100 Graham Williams>
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
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Summary.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
    await navigateToTab(tester, 'Explore');
    await navigateToFeature(tester, 'Summary', SummaryPanel);
    await tapButton(tester, 'Generate Dataset Summary');
    await tester.pump(hack);
    await navigateToPage(tester, 1, 'Summary of the Dataset');
    await verifySelectableText(tester, [
      'Length:20000',
      'f:12435',
    ]);
    await navigateToPage(tester, 2, 'Dataset Glimpse');
    await verifySelectableText(
      tester,
      ['Rows: 20,000'],
    );
    await navigateToPage(tester, 3, 'Skim the Dataset');
    await verifySelectableText(
      tester,
      ['20000'],
    );
    await navigateToPage(tester, 4, 'Kurtosis and Skewness');
    await verifySelectableText(
      tester,
      [
        '2.12090961',
        '0.099352734',
      ],
    );
  });
}
