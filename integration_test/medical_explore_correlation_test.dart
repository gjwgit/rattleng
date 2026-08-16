/// EXPLORE tab: Correlation Large Dataset Test.
//
// Time-stamp: <Tuesday 2026-01-06 14:42:30 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors:  Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_dataset_role.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Large Correlation:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
      await verifyDatasetRole('gender', 'Target');
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation');
      await tapButton(tester, 'Perform Correlation Analysis');

      // 20260106 gjw Page 4 contains the numeric data. It used to be page 1.

      await navigateToPage(
        tester,
        4,
        back: 1,
        title: 'Correlation - Numeric Data',
      );
      await verifySelectableText(tester, [
        'bmi                   0.24                0.12   1.00   0.39   0.05           0.03          -0.01',
        'weight                0.20                0.26   0.39   1.00   0.04           0.02          -0.01',
        'smoking_status        0.08                0.11   0.05   0.04   1.00           0.01           0.00',
      ]);

      // Verify the content of the page 2.

      await navigateToPage(
        tester,
        2,
        title: 'Variable Correlation Plot',
      );

      //  20250403 gjw Set the dataset role of gender from TARGET to IGNORE to
      //  test when there is no target.

      await navigateToTab(tester, 'Dataset');
      await navigateToPage(tester, 1, back: 1);
      await setDatasetRole(tester, 'gender', 'Ignore');
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation');
      await tapButton(tester, 'Perform Correlation Analysis');
      await navigateToPage(tester, 4, back: 2);
      await verifySelectableText(tester, [
        'bmi                   0.24                0.12   1.00   0.39   0.05           0.03          -0.01',
        'weight                0.20                0.26   0.39   1.00   0.04           0.02          -0.01',
        'smoking_status        0.08                0.11   0.05   0.04   1.00           0.01           0.00',
      ]);
    });
  });
}
