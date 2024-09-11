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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Transform DEMO:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      final container = await initApp(tester);

      await tester.pump(pause);
      await openDemoDataset(tester);
      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Impute', ImputePanel);

      await checkMissingVariable(container, 'sunshine');

      await pressFirstButton(tester, 'Impute Missing Values');
      await tester.pump(hack);

      await verifyPageContent(
        tester,
        'Dataset Summary',
        'IZR_sunshine',
      );

      await verifyMultipleTextContent(
        tester,
        [
          'Min.   : 0.000',
          '1st Qu.: 5.900',
          'Median : 8.600',
          'Mean   : 7.845',
          '3rd Qu.:10.500',
          'Max.   :13.600',
        ],
      );

      await navigateToTab(tester, 'Dataset');
      await tester.pump(pause);

      await verifyImputedVariable(container, 'IZR_sunshine');
      await checkVariableNotMissing(container, 'IZR_sunshine');

      container.dispose();
    });
  });
}
