/// EXPLORE tab: Correlation Large Dataset Test.
//
// Time-stamp: <Monday 2024-09-02 20:19:03 +1000 Graham Williams>
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

import 'package:rattle/features/correlation/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_large_dataset.dart';
import 'utils/press_button.dart';
import 'utils/verify_page_content.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Large Correlation:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openLargeDataset(tester);
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation', CorrelationPanel);
      await pressButton(tester, 'Perform Correlation Analysis');

      // Verify the content of the page 1.

      await verifyPageContent(
        tester,
        'Correlation - Numeric Data',
        'cholesterol_level                1.00           0.00           0.00  -0.01',
      );
      await verifyTextContent(
        tester,
        'smoking_status                   0.00           0.01           1.00   0.04  0.05',
      );
      await verifyTextContent(
        tester,
        'bmi                             -0.01           0.03           0.05   0.39  1.00',
      );
      await verifyTextContent(
        tester,
        'age_at_consultation              0.00           0.06           0.08   0.20  0.24',
      );

      // Verify the content of the page 2.

      // TODO 20240902 kev HOW TO CONFIRM THE IMAGE?
      //
      // Must be something we can do to confirm the image. Not sure what yet!

      await verifyPageContent(tester, 'Variable Correlation Plot');
    });
  });
}
