/// WEATHER dataset TRANSFORM tab RECODE feature.
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
import 'package:rattle/features/recode/panel.dart';

import 'package:rattle/main.dart' as app;

import 'utils/check_variable_not_missing.dart';
import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_selected_variable.dart';
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

  group('WEATHER TRANSFORM RECODE:', () {
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
      await navigateToFeature(tester, 'Recode', RecodePanel);
      await tapButton(tester, 'Recode Variable Values');
      await tester.pump(delay);
      // await gotoNextPage(tester);

      await verifyPage(
        'Dataset Summary',
        'BQT_min_temp_4',
      );
      await scrollUntilFindKey(tester, 'text_page');

      // Verify specific statistical values for the imputed 'BQT_min_temp_4' variable.

      await verifySelectableText(
        tester,
        [
          '[-6.2,1.1] :94',
          '(1.1,6.7]  :89',
          '(6.7,12.2] :91',
          '(12.2,20.8]:91',
        ],
      );

      await navigateToTab(tester, 'Dataset');
      await scrollDown(tester);
      await verifyImputedVariable(tester, 'BQT_min_temp_4');
      await checkVariableNotMissing(tester, 'BQT_min_temp_4');

      // 2. Select and test chip "KMeans"

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Recode', RecodePanel);
      await verify_tap_chip(
        tester,
        'KMeans',
        'Recode Variable Values',
        'BKM_min_temp_4',
        [
          '[-6.2,0.6] :87',
          '(0.6,6.5]  :93',
          '(6.5,12.1] :94',
          '(12.1,20.8]:91',
        ],
      );

      // 3. Select and test chip "Equal Width"

      await verify_tap_chip(
        tester,
        'Equal Width',
        'Recode Variable Values',
        'BEQ_min_temp_4',
        [
          '(-6.23,0.55]: 83',
          '(0.55,7.3]  :107',
          '(7.3,14.1]  :118',
          '(14.1,20.8] : 57',
        ],
      );

      // 4. Select and test chip "As Categoric"

      await verify_tap_chip(
        tester,
        'As Categoric',
        'Recode Variable Values',
        'TFC_min_temp',
        [
          '-0.6   :  6',
          '12.8   :  6',
          '1.6    :  5',
          '2.1    :  5',
          '17.2   :  5',
          '(Other):333',
        ],
      );

      await setSelectedVariable(tester, 'wind_dir_9am');

      // 5. Select and test chip "As Numeric"
      //TODO kevin , failing here

      await verify_tap_chip(
        tester,
        'As Numeric',
        'Recode Variable Values',
        'TNM_wind_dir_9am',
        [
          'Min.   : 1.000',
          '1st Qu.: 5.000',
          'Median : 8.000',
          'Mean   : 8.073',
          '3rd Qu.:11.000',
          'Max.   :16.000',
          'NA\'s   :52',
        ],
      );

      // 6. Select and test chip "Indicator Variable"

      await verify_tap_chip(
        tester,
        'Indicator Variable',
        'Recode Variable Values',
        'TIN_wind_gust_dir_E',
        [
          'Min.   :0.0000',
          '1st Qu.:0.0000',
          'Median :0.0000',
          'Mean   :0.1136',
          '3rd Qu.:0.0000',
          'Max.   :1.0000',
          'NA\'s   :4',
        ],
      );

      // 7. Select and test chip "Join Categorics"

      await verify_tap_chip(
        tester,
        'Join Categorics',
        'Recode Variable Values',
        'TJN_wind_gust_dir__wind_dir_9am',
        [
          'NW_NNW : 15',
          'NNW_NNW: 10',
          'E_SSE  :  8',
          'E_SE   :  7',
          'NW_NW  :  7',
          '(Other):263',
          'NA\'s   : 55',
        ],
      );
    });
  });
}
