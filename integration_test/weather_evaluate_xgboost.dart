/// WEATHER -> XGBOOST -> EVALUATE
//
// Time-stamp: <Monday 2025-03-24 13:40:51 +1100 Graham Williams>
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER -> XGBOOST -> EVALUATE:', () {
    testWidgets('verify.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost');
      await tapButton(tester, 'Build Boosted Trees');
      await navigateToPage(tester, 1, title: 'XGBoost - Summary', back: 1);
      await verifySelectableText(
        tester,
        [
          '        Feature        Gain       Cover Frequency  Importance',
          '   humidity_3pm 0.245579925 0.208283402     0.130 0.245579925',
          '   pressure_3pm 0.189113475 0.136315038     0.100 0.189113475',
          '       min_temp 0.096486981 0.088880259     0.095 0.096486981',
          '   pressure_9am 0.096343773 0.077483004     0.085 0.096343773',
          'wind_gust_speed 0.079431444 0.108244312     0.130 0.079431444',
          ' wind_speed_3pm 0.068648208 0.071066295     0.075 0.068648208',
          '       max_temp 0.055045877 0.057362528     0.065 0.055045877',
        ],
      );
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await navigateToPage(tester, 1, title: 'Error Matrix', back: 1);
      await verifySelectableText(
        tester,
        [
          'No  10   4  28.6',
          'Yes  6   2  75.0',
          'No  45.5 18.2  28.6',
          'Yes 27.3  9.1  75.0',
          'Overall Error = 45.45%; Average Error = 51.79%.',
        ],
      );
    });
  });
}
