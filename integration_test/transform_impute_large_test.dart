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

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_large_dataset.dart';
import 'utils/press_first_button.dart';
import 'utils/verify_multiple_text.dart';
import 'utils/verify_page_content.dart';
import 'utils/check_missing_variable.dart';
import 'utils/check_variable_not_missing.dart';
import 'utils/init_app.dart';
import 'utils/verify_imputed_variable.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Transform LARGE:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      final container = await initApp(tester);

      await tester.pump(pause);
      await openLargeDataset(tester);
      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Impute', ImputePanel);

      await checkMissingVariable(container, 'middle_name');

      await pressFirstButton(tester, 'Impute Missing Values');
      await tester.pump(hack);

      await verifyPageContent(
        tester,
        'Dataset Summary',
        'IZR_middle_name',
      );

      await verifyMultipleTextContent(
        tester,
        [
          'Missing: 1987',
          'lee    :  563',
          'michael:  262',
          'ann    :  253',
          'wayne  :  239',
          'edward :  237',
        ],
      );

      await navigateToTab(tester, 'Dataset');
      await tester.pump(pause);

      await verifyImputedVariable(container, 'IZR_middle_name');
      await checkVariableNotMissing(container, 'IZR_middle_name');

      container.dispose();
    });
  });
}
