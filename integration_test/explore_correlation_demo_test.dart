/// Test and demonstrate the EXPLORE tab CORRELATION feature with the DEMO dataset.
//
// Time-stamp: <Tuesday 2024-09-10 17:00:01 +1000 Graham Williams>
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
import 'utils/verify_page_content.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Demo Correlation:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDemoDataset(tester);
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation', CorrelationPanel);
      await pressButton(tester, 'Perform Correlation Analysis');

      await tester.pump(longHack);

      // Verify the content of the page 1.

      await verifyPageContent(
        tester,
        'Correlation - Numeric Data',
        'pressure_9am            1.00',
      );
      await verifyTextContent(
        tester,
        'wind_speed_3pm         -0.36        -0.34        -0.27           1.00',
      );
      await verifyTextContent(
        tester,
        'rainfall               -0.33        -0.25         0.15           0.06',
      );
      await verifyTextContent(
        tester,
        'wind_gust_speed        -0.54        -0.53        -0.35           0.69',
      );

      // Verify the content of the page 2.

      await verifyPageContent(tester, 'Variable Correlation Plot');
      await tester.pump(pause);
    });
  });
}
