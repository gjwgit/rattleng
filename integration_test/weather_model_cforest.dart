/// WEATHER -> CFOREST
//
// Time-stamp: <Tuesday 2025-03-25 13:09:14 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/navigate_to_page.dart';
import 'utils/load_demo_dataset.dart';
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
      // 2025-02-14 10:24 gjw I tried testing the TITLE but could not get it to
      // work for this page - 'Variable Importance'.
      await navigateToPage(
        tester,
        2,
        back: 1,
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
        'humidity_3pm       humidity_3pm  0.0247096774',
        'pressure_3pm       pressure_3pm  0.0120000000',
        'pressure_9am       pressure_9am  0.0060645161',
        'min_temp               min_temp  0.0036989247',
        'wind_dir_3pm       wind_dir_3pm  0.0031182796',
        'rainfall               rainfall  0.0018924731',
        'wind_gust_speed wind_gust_speed  0.0017634409',
        'wind_speed_3pm   wind_speed_3pm  0.0015483871',
        'wind_gust_dir     wind_gust_dir  0.0011827957',
        'wind_speed_9am   wind_speed_9am  0.0010967742',
        'cloud_3pm             cloud_3pm  0.0007311828',
        'humidity_9am       humidity_9am  0.0005161290',
        'max_temp               max_temp  0.0004516129',
        'temp_3pm               temp_3pm  0.0004516129',
        'cloud_9am             cloud_9am -0.0001290323',
      ]);
    });
  });
}
