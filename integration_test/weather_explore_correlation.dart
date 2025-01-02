/// Test WEATHER dataset EXPLORE tab CORRELATION feature.
//
// Time-stamp: <Friday 2024-12-27 15:52:50 +1100 Graham Williams>
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
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_text.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Demo Correlation:', () {
    testWidgets('Weather Explore Correlation.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDemoDataset(tester);

      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation', CorrelationPanel);
      await tapButton(tester, 'Perform Correlation Analysis');

      await tester.pump(hack);

      await gotoNextPage(tester);
      await verifyPage('Correlation - Numeric Data', '1.00');

      await verifyText(
        tester,
        [
          'risk_mm                -0.20        -0.22         0.06',
          'pressure_9am            1.00         0.97         0.25',
          'humidity_9am            0.25         0.23         1.00',
        ],
      );

      await gotoNextPage(tester);
      await verifyPage('Variable Correlation Plot');
      await tester.pump(interact);
    });
  });
}
