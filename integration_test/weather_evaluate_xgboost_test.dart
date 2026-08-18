/// WEATHER -> XGBOOST -> EVALUATE
//
// Time-stamp: <Tuesday 2025-03-25 13:02:11 +1100 Graham Williams>
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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
/// Authors:  Kevin Wang
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';
import 'utils/wait_for_r.dart';

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

      // 20260818 gjw Wait for R to finish building before looking at the
      // summary it produces. See `utils/wait_for_r.dart`.

      await waitForR(tester);

      await navigateToPage(tester, 1, title: 'XGBoost - Summary', back: 1);
      await verifySelectableText(tester, [
        '          Feature        Gain       Cover   Frequency  Importance',
        '           <char>       <num>       <num>       <num>       <num>',
        '     humidity_3pm 0.230774034 0.209658503 0.118811881 0.230774034',
        '     pressure_3pm 0.187928038 0.118403422 0.103960396 0.187928038',
        '     pressure_9am 0.108964834 0.082466319 0.099009901 0.108964834',
        '         min_temp 0.094356101 0.110981246 0.133663366 0.094356101',
        '         max_temp 0.063723709 0.052837482 0.069306931 0.063723709',
        '   wind_speed_3pm 0.063425970 0.069338825 0.069306931 0.063425970',
        '  wind_gust_speed 0.061561271 0.086464581 0.089108911 0.061561271',
        '         rainfall 0.054146403 0.061947650 0.099009901 0.054146403',
        '   wind_dir_3pmNW 0.027691494 0.031774498 0.014851485 0.027691494',
        '         temp_9am 0.025842172 0.032745099 0.049504950 0.025842172',
        '        cloud_3pm 0.022117158 0.051494291 0.044554455 0.022117158',
      ]);
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await navigateToPage(tester, 1, title: 'Error Matrix', back: 1);
      await verifySelectableText(tester, [
        '   No  11   3  21.4',
        '   Yes  6   2  75.0',
        '   No  50.0 13.6  21.4',
        '   Yes 27.3  9.1  75.0',
        '',
        'Overall Error = 40.91%; Average Error = 48.21%.',
      ]);
    });
  });
}
