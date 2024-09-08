/// Test the Transform tab Impute/Rescale/Recode feature on the DEMO dataset.
//
// Time-stamp: <Tuesday 2024-09-03 09:07:59 +1000 Graham Williams>
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
import 'package:rattle/features/recode/panel.dart';
import 'package:rattle/features/rescale/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/navigate_to_transform.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/press_button.dart';
import 'utils/verify_page_content.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Transform DEMO:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDemoDataset(tester);
      await navigateToTransformTab(tester);

      // Impute page.

      await navigateToTab(tester, 'Impute', ImputePanel);

      await pressFirstButton(tester, 'Impute Missing Values');

      // Verify the content of the page.

      await verifyPageContent(
        tester,
        'Dataset Summary',
        '2007-11-01',
      );
      await verifyTextContent(
        tester,
        '1st Qu.:2008-01-31',
      );
      await verifyTextContent(
        tester,
        'Min.   :13.00',
      );
      await verifyTextContent(
        tester,
        '1st Qu.:1015.4',
      );

      // Rescale page.

      await navigateToTab(tester, 'Rescale', RescalePanel);

      await pressFirstButton(tester, 'Rescale Variable Values');

      // Verify the content of the page.

      await verifyPageContent(
        tester,
        'Dataset Summary',
        '2007-11-01',
      );
      await verifyTextContent(
        tester,
        'Min.   :13.00',
      );
      await verifyTextContent(
        tester,
        'Median :1020.1',
      );
      await verifyTextContent(
        tester,
        'Max.   :39.800',
      );

      // Recode page.

      await navigateToTab(tester, 'Recode', RecodePanel);

      await pressFirstButton(tester, 'Recode Variable Values');

      // Verify the content of the page.

      await verifyPageContent(
        tester,
        'Dataset Summary',
        '2007-11-01',
      );
      await verifyTextContent(
        tester,
        '1st Qu.:31.00',
      );
      await verifyTextContent(
        tester,
        'Median :39.00',
      );
      await verifyTextContent(
        tester,
        'Mean   :39.84',
      );
    });
  });
}
