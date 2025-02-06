/// WEATHER dataset TRANSFORM tab RESCALE feature.
//
// Time-stamp: <Tuesday 2025-02-04 10:34:15 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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

import 'package:rattle/features/rescale/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/check_variable_not_missing.dart';
import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/verify_rescale_tap_chip.dart';
import 'utils/scroll_down.dart';
import 'utils/tap_button.dart';
import 'utils/unify_on.dart';
import 'utils/verify_imputed_variable.dart';
import 'utils/verify_selectable_text.dart';
import 'utils/scroll_until_find_key.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER TRANSFORM RESCALE:', () {
    testWidgets('min_temp.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await unifyOn(tester);
      await loadDemoDataset(tester);
      await tester.pump(delay);

      // 1. Default chip "Recenter". Do not use rescale_tap_chip_verify because
      // it is a special case.

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Rescale', RescalePanel);
      await tapButton(tester, 'Rescale Variable Values');
      await tester.pump(delay);
      await gotoNextPage(tester);
      await verifyPage(
        'Dataset Summary',
        'RRC_min_temp',
      );
      await scrollUntilFindKey(tester, 'text_page');

      // Verify specific statistical values for the imputed 'RRC_min_temp' variable.

      await verifySelectableText(
        tester,
        [
          'Min.   :-1.946941', // Minimum value of 'RRC_min_temp'.
          '1st Qu.:-0.841097', // First quartile value of 'RRC_min_temp'.
          'Median : 0.007221', // Median value of 'RRC_min_temp'.
          'Mean   : 0.000000', // Mean value of 'RRC_min_temp'.
          '3rd Qu.: 0.825243', // Third quartile value of 'RRC_min_temp'.
          'Max.   : 2.143167', // Maximum value of 'RRC_min_temp'.
        ],
      );

      await navigateToTab(tester, 'Dataset');
      await scrollDown(tester);
      await verifyImputedVariable(tester, 'RRC_min_temp');
      await checkVariableNotMissing(tester, 'RRC_min_temp');

      // 2. Select and test chip "Scale [0, 1]"

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Rescale', RescalePanel);
      await verify_tap_chip(
        tester,
        'Scale [0-1]',
        'Rescale Variable Values',
        'R01_min_temp',
        [
          'Min.   :0.0000', // Minimum value of 'R01_min_temp'.
          '1st Qu.:0.2704', // First quartile value of 'R01_min_temp'.
          'Median :0.4778', // Median value of 'R01_min_temp'.
          'Mean   :0.4760', // Mean value of 'R01_min_temp'.
          '3rd Qu.:0.6778', // Third quartile value of 'R01_min_temp'.
          'Max.   :1.0000', // Maximum value of 'R01_min_temp'.
        ],
      );

      // 3. Select and test chip "-Median/MAD"

      await verify_tap_chip(
        tester,
        '-Median/MAD',
        'Rescale Variable Values',
        'RMD_min_temp',
        [
          'Min.   :-1.553738', // Minimum value of 'RMD_min_temp'.
          '1st Qu.:-0.674491', // First quartile value of 'RMD_min_temp'.
          'Median : 0.000000', // Median value of 'RMD_min_temp'.
          'Mean   :-0.005742', // Mean value of 'RMD_min_temp'.
          '3rd Qu.: 0.650402', // Third quartile value of 'RMD_min_temp'.
          'Max.   : 1.698271', // Maximum value of 'RMD_min_temp'.
        ],
      );

      // 4. Select and test chip "Natural Log"

      await verify_tap_chip(
        tester,
        'Natural Log',
        'Rescale Variable Values',
        'RLG_min_temp',
        [
          'Min.   :-2.303', // Minimum value of 'RLG_min_temp'.
          '1st Qu.: 1.493', // First quartile value of 'RLG_min_temp'.
          'Median : 2.186', // Median value of 'RLG_min_temp'.
          'Mean   : 1.857', // Mean value of 'RLG_min_temp'.
          '3rd Qu.: 2.588', // Third quartile value of 'RLG_min_temp'.
          'Max.   : 3.035', // Maximum value of 'RLG_min_temp'.
          'NA\'s   :71', // Number of missing values in 'RLG_min_temp'.
        ],
      );

      // 5. Select and test chip "Log 10"

      await verify_tap_chip(
        tester,
        'Log 10',
        'Rescale Variable Values',
        'R10_min_temp',
        [
          'Min.   :-1.0000', // Minimum value of 'R10_min_temp'.
          '1st Qu.: 0.6483', // First quartile value of 'R10_min_temp'.
          'Median : 0.9494', // Median value of 'R10_min_temp'.
          'Mean   : 0.8064', // Mean value of 'R10_min_temp'.
          '3rd Qu.: 1.1239', // Third quartile value of 'R10_min_temp'.
          'Max.   : 1.3181', // Maximum value of 'R10_min_temp'.
          'NA\'s   :71', // Number of missing values in 'R10_min_temp'.
        ],
      );

      // 6. Select and test chip "Rank"

      await verify_tap_chip(
        tester,
        'Rank',
        'Rescale Variable Values',
        'RRK_min_temp',
        [
          'Min.   :  1.0', // Minimum value of 'RRK_min_temp'.
          '1st Qu.: 92.5', // First quartile value of 'RRK_min_temp'.
          'Median :183.0', // Median value of 'RRK_min_temp'.
          'Mean   :183.0', // Mean value of 'RRK_min_temp'.
          '3rd Qu.:273.0', // Third quartile value of 'RRK_min_temp'.
          'Max.   :365.0', // Maximum value of 'RRK_min_temp'.
        ],
      );

      // 6. Select and test chip "Interval"

      await verify_tap_chip(
        tester,
        'Interval',
        'Rescale Variable Values',
        'RIN_min_temp_100',
        [
          'Min.   : 0.00', // Minimum value of 'RIN_min_temp_100'.
          '1st Qu.:27.00', // First quartile value of 'RIN_min_temp_100'.
          'Median :47.00', // Median value of 'RIN_min_temp_100'.
          'Mean   :47.15', // Mean value of 'RIN_min_temp_100'.
          '3rd Qu.:67.00', // Third quartile value of 'RIN_min_temp_100'.
          'Max.   :99.00', // Maximum value of 'RIN_min_temp_100'.
        ],
      );
    });
  });
}
