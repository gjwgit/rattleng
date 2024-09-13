/// Test the Transform tab Impute/Rescale/Recode feature on the DEMO dataset.
//
// Time-stamp: <Monday 2024-09-09 19:17:11 +1000 Graham Williams>
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

import 'package:rattle/features/impute/panel.dart';

import 'utils/check_missing_variable.dart';
import 'utils/check_variable_not_missing.dart';
import 'utils/delays.dart';
import 'utils/init_app.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/press_first_button.dart';
import 'utils/verify_imputed_variable.dart';
import 'utils/verify_multiple_text.dart';
import 'utils/verify_page_content.dart';

void main() {
  // Initialize the integration test bindings to enable the use of integration test features.

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Define a group of tests related to the Transform tab on the DEMO dataset.

  group('Transform DEMO:', () {
    // Define a test case that builds the page and runs checks.

    testWidgets('build, page.', (WidgetTester tester) async {
      // Initialize the app and get the ProviderContainer for state management.

      final container = await initApp(tester);

      // Allow time for the UI to settle after initialization.

      await tester.pump(pause);

      // Open the demo dataset in the app.

      await openDemoDataset(tester);

      // Navigate to the 'Transform' tab in the app.

      await navigateToTab(tester, 'Transform');

      // Within the 'Transform' tab, navigate to the 'Impute' feature.

      await navigateToFeature(tester, 'Impute', ImputePanel);

      // Step 1: Check if the variable 'sunshine' has missing values.

      await checkMissingVariable(container, 'sunshine');

      // Step 2: Simulate pressing the button to impute missing values.

      await pressFirstButton(tester, 'Impute Missing Values');

      // Allow the UI to settle after the imputation action.

      await tester.pump(hack);

      // Verify that the page content includes the expected dataset summary with 'IZR_sunshine'.

      await verifyPageContent(
        tester,
        'Dataset Summary',
        'IZR_sunshine',
      );

      // Verify specific statistical values for the imputed 'IZR_sunshine' variable.

      await verifyMultipleTextContent(
        tester,
        [
          'Min.   : 0.000', // Minimum value of 'IZR_sunshine'.
          '1st Qu.: 5.900', // First quartile value of 'IZR_sunshine'.
          'Median : 8.600', // Median value of 'IZR_sunshine'.
          'Mean   : 7.845', // Mean value of 'IZR_sunshine'.
          '3rd Qu.:10.500', // Third quartile value of 'IZR_sunshine'.
          'Max.   :13.600', // Maximum value of 'IZR_sunshine'.
        ],
      );

      // Step 2.5: Navigate to the 'Dataset' tab to ensure the UI updates correctly.

      await navigateToTab(tester, 'Dataset');

      // Allow time for the UI to settle after navigating to the 'Dataset' tab.

      await tester.pump(pause);

      // Step 3: Verify that the imputed variable 'IZR_sunshine' is present in the dataset.

      await verifyImputedVariable(container, 'IZR_sunshine');

      // Step 4: Check that the imputed variable 'IZR_sunshine' is no longer listed as missing.

      await checkVariableNotMissing(container, 'IZR_sunshine');

      // Dispose of the ProviderContainer to clean up resources and prevent memory leaks.
      container.dispose();
    });
  });
}
