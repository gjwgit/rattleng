/// WEATHER -> CFOREST
//
// Time-stamp: <Thursday 2025-05-08 14:40:16 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER -> CFOREST:', () {
    testWidgets('model, varimp.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Forest');
      await tester.pump(interact);
      await tapChip(tester, 'Conditional');
      await tapButton(tester, 'Build Random Forest');
      await addDelay(tester, 2);
      await navigateToPage(tester, 1, back: 1, title: 'Random Forest Model');
      await verifySelectableText(tester, [
        'Number of trees:  500',
        'Number of observations:  254',
      ]);
      await navigateToPage(tester, 2, back: 1, title: 'Sample Rules');
      await verifySelectableText(tester, [
        '1) pressure_9am <= 1018.3; criterion = 0.993, statistic = 24.293',
        '2) wind_speed_3pm <= 22; criterion = 0.99, statistic = 17.177',
        '3) max_temp <= 22.7; criterion = 0.972, statistic = 11.053',
        '4)*  weights = 0 ',
        '3) max_temp > 22.7',
        '5) wind_gust_speed <= 44; criterion = 0.936, statistic = 3.442',
        '6)*  weights = 0 ',
        '5) wind_gust_speed > 44',
        '7)*  weights = 0 ',
        '2) wind_speed_3pm > 22',
        '8) temp_3pm <= 21.3; criterion = 0.926, statistic = 10.5',
        '9)*  weights = 0 ',
        '8) temp_3pm > 21.3',
        '10)*  weights = 0 ',
      ]);
      await navigateToPage(
        tester,
        3,
        back: 2,
        title: 'Variable Importance — Numeric',
      );
      // 20250212 gjw Oddly on one failure `0.025935...` was not found, yet
      // presumably `humidity_3pm` was found. Add a delay to see if this is
      // repeated.
      //
      // 20250214 gjw Still seeing occasional failure. Add extra delay. Though
      // maybe it's some randomness in the number? Try truncating it to `0.0259`
      // here next time.
      await addDelay(tester, 4);
      await verifySelectableText(tester, [
        '                       Variable    Importance',
        'humidity_3pm       humidity_3pm  5.000000e-02',
        'pressure_3pm       pressure_3pm  2.821505e-02',
        'pressure_9am       pressure_9am  4.903226e-03',
        'wind_speed_3pm   wind_speed_3pm  3.182796e-03',
        'wind_gust_speed wind_gust_speed  1.677419e-03',
        'wind_dir_3pm       wind_dir_3pm  1.548387e-03',
        'min_temp               min_temp  1.204301e-03',
        'temp_3pm               temp_3pm  9.247312e-04',
        'max_temp               max_temp  6.666667e-04',
        'cloud_3pm             cloud_3pm  5.591398e-04',
        'wind_gust_dir     wind_gust_dir  4.301075e-04',
        'wind_speed_9am   wind_speed_9am  3.010753e-04',
        'rainfall               rainfall  1.935484e-04',
        'temp_9am               temp_9am  1.290323e-04',
        'humidity_9am       humidity_9am  6.451613e-05',
      ]);
    });
  });
}
