/// Test WEATHER dataset EXPLORE tab MISSING feature.
//
// Time-stamp: <Friday 2024-12-27 15:56:42 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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
/// Authors:  Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/missing/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/goto_next_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/open_weather_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Demo Explore Missing', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await openWeatherDataset(tester);

    await navigateToTab(tester, 'Explore');

    await navigateToFeature(tester, 'Missing', MissingPanel);

    await tapButton(tester, 'Perform Missing Analysis');

    await gotoNextPage(tester);
    await verifyPage('Patterns of Missing Data - Textual', '380');

    await gotoNextPage(tester);
    await verifyPage('Patterns of Missing Values - Visual');

    await gotoNextPage(tester);
    await verifyPage('Aggregation of Missing Values - Textual', '172');

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
