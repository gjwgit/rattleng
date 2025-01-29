/// Test the Transform tab Impute/Rescale/Recode feature on the DEMO dataset.
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/impute/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/press_first_button.dart';
import 'utils/unify_on.dart';
import 'utils/verify_imputed_variable.dart';
import 'utils/verify_selectable_text.dart';
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

      await navigateToFeature(tester, 'Impute', ImputePanel);

      await pressFirstButton(tester, 'Impute Missing Values');

      // Allow the UI to settle after the imputation action.

      await tester.pump(delay);

      await gotoNextPage(tester);

      // Verify that the page content includes the expected dataset summary with 'IMN_rainfall'.

      await verifyPage(
        'Dataset Summary',
        'IMN_rainfall',
      );

      // Standard mouse wheel scroll amount and find the first Scrollable widget by key.

      await tester.scrollUntilVisible(
        find.byKey(const PageStorageKey('text_page')),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Verify specific statistical values for the imputed 'IMN_rainfall' variable.

      await verifySelectableText(
        tester,
        [
          'Min.   : 0.000', // Minimum value of 'IMN_rainfall'.
          '1st Qu.: 0.000', // First quartile value of 'IMN_rainfall'.
          'Median : 0.000', // Median value of 'IMN_rainfall'.
          'Mean   : 1.825', // Mean value of 'IMN_rainfall'.
          '3rd Qu.: 0.200', // Third quartile value of 'IMN_rainfall'.
          'Max.   :44.800', // Maximum value of 'IMN_rainfall'.
        ],
      );

      // Step 2.5: Navigate to the 'Dataset' tab to ensure the UI updates correctly.

      await navigateToTab(tester, 'Dataset');

      // // Allow time for the UI to settle after navigating to the 'Dataset' tab.

      // await tester.pump(interact);

      // Step 3: Verify that the imputed variable 'IZR_rainfall' is present in the dataset.

      await verifyImputedVariable(container, 'IMN_rainfall');

      // Step 4: Check that the imputed variable 'IZR_rainfall' is no longer listed as missing.

      // await checkVariableNotMissing(container, 'IZR_rainfall');

      // Dispose of the ProviderContainer to clean up resources and prevent memory leaks.
      // container.dispose();
    });
  });
}
