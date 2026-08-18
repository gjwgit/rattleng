/// WEATHER dataset EXPLORE tab SUMARY feature.
///
// Time-stamp: <Friday 2025-03-21 17:14:42 +1100 Graham Williams>
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams, Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';
import 'utils/wait_for_r.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER EXPLORE SUMMARY:', () {
    testWidgets('.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Summary');
      await tapButton(tester, 'Generate Dataset Summary');
      await waitForR(tester);
      await navigateToPage(tester, 1, title: 'Summary of the Dataset');
      await verifySelectableText(tester, [
        '2023-07-01',
        '-6.200', // min_temp
        '8.40', // max_temp.
      ]);
      await gotoNextPage(tester); // Datset Glimpse
      await gotoNextPage(tester); // Skim the Dataset
      await verifySelectableText(tester, [
        'Number of columns          21',
        'Number of rows             365',
        'rainfall                2         0.995    1.82',
      ]);
      await gotoNextPage(tester); // Kurtosis and Skewness
      await verifySelectableText(tester, [
        '-1.0832020',
        '-1.0649102',
        '4.27691518',
      ]);
    });
  });
}
