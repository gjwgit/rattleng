/// Test WEATHER dataset EXPLORE tab MISSING feature.
//
// Time-stamp: <Sunday 2025-08-10 16:12:56 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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
/// Authors:  Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Demo Explore Missing', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loadDemoDataset(tester, 'Weather');
    await navigateToTab(tester, 'Explore');
    await navigateToFeature(tester, 'Missing');
    await tapButton(tester, 'Perform Missing Analysis');
    await gotoNextPage(tester);
    // 20250207 gjw Add a delay for ecosysl.
    await tester.pump(delay);
    await verifyPage('Count of Missing Values - Textual');
    await gotoNextPage(tester);
    await verifyPage('Patterns of Missing Data - Textual');
    await gotoNextPage(tester);
    await verifyPage('Patterns of Missing Values - Visual');
    await gotoNextPage(tester);
    await verifyPage('Correlation of Missing Values - Visual');
    await gotoNextPage(tester);
    await verifyPage('Aggregation of Missing Values - Visual');
    await gotoNextPage(tester);
    await verifyPage('Visualisation of Observations with Missing Values');
    await gotoNextPage(tester);
    await verifyPage('Comparison of Counts of Missing Values');
    await gotoNextPage(tester);
    await verifyPage('Patterns of Missingness');
  });
}
