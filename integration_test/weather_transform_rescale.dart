/// Test the Transform tab Rescale feature on the DEMO dataset.
//
// Time-stamp: <Friday 2024-12-27 16:23:12 +1100 Graham Williams>
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
import 'utils/press_first_button.dart';
import 'utils/scroll_down.dart';
import 'utils/unify_on.dart';
import 'utils/verify_imputed_variable.dart';
import 'utils/verify_selectable_text.dart';
import 'utils/scroll_until.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Transform DEMO:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await unifyOn(tester);

      await loadDemoDataset(tester);

      await navigateToTab(tester, 'Transform');

      await navigateToFeature(tester, 'Rescale', RescalePanel);

      await pressFirstButton(tester, 'Rescale Variable Values');

      await tester.pump(delay);

      await gotoNextPage(tester);

      // Verify that the page content includes the expected dataset summary with 'RRC_min_temp'.

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

      // Step 2: Navigate to the 'Dataset' tab to ensure the UI updates correctly.

      await navigateToTab(tester, 'Dataset');

      await scrollDown(tester);

      // Step 3: Verify that the imputed variable 'IMN_rainfall' is present in the dataset.

      await verifyImputedVariable(tester, 'RRC_min_temp');

      // Step 4: Check that the imputed variable 'IMN_rainfall' is no longer listed as missing.

      await checkVariableNotMissing(tester, 'RRC_min_temp');
    });
  });
}
