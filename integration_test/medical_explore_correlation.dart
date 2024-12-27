/// EXPLORE tab: Correlation Large Dataset Test.
//
// Time-stamp: <Monday 2024-10-14 13:33:57 +1100 Graham Williams>
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
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_dataset_by_path.dart';
import 'utils/tap_button.dart';
import 'utils/verify_next_page.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Large Correlation:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDatasetByPath(tester, 'integration_test/medical.csv');
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation', CorrelationPanel);
      await tapButton(tester, 'Perform Correlation Analysis');

      // Verify the content of the page 1.

      await verifyPage(
        'Correlation - Numeric Data',
        'cholesterol_level                1.00           0.00           0.00  -0.01',
      );
      await verifyText(tester, [
        'smoking_status                   0.00           0.01           1.00   0.04  0.05',
        'bmi                             -0.01           0.03           0.05   0.39  1.00',
        'age_at_consultation              0.00           0.06           0.08   0.20  0.24',
      ]);

      // Verify the content of the page 2.

      // TODO 20240902 kev HOW TO CONFIRM THE IMAGE?
      //
      // Must be something we can do to confirm the image. Not sure what yet!

      await gotoNextPage(tester);

      await verifyPage('Variable Correlation Plot');
    });
  });
}
