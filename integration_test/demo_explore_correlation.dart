/// Test and demonstrate the EXPLORE tab CORRELATION feature with the DEMO dataset.
//
// Time-stamp: <2024-10-06 06:20:03 gjw>
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
/// Authors:  Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/correlation/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/press_button.dart';
import 'utils/verify_multiple_text.dart';
import 'utils/verify_next_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Demo Correlation:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDemoDataset(tester);

      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation', CorrelationPanel);
      await pressButton(tester, 'Perform Correlation Analysis');

      await tester.pump(hack);

      // 20241006 gjw Try a second time to make sure we go to the right page.

      await pressButton(tester, 'Perform Correlation Analysis');

      // Verify the content of the page.

      await verifyPage(
        'Correlation - Numeric Data',
        '1.00',
      );

      await verifyMultipleTextContent(
        tester,
        [
          // Verify risk_mm in the row.

          'risk_mm                -0.20        -0.22         0.06',

          // Verify pressure_9am in the row.

          'pressure_9am            1.00         0.97         0.25',

          // Verify humidity_9am in the row.

          'humidity_9am            0.25         0.23         1.00',
        ],
      );

      // Verify the content of the next page.

      await verifyNextPage(tester, 'Variable Correlation Plot');
      await tester.pump(interact);
    });
  });
}
