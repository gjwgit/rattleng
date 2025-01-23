/// Build BOOST model.
//
// Time-stamp: <Sunday 2024-10-13 13:19:44 +1100 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/boost/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Model Boost Ada', () {
    testWidgets('Load, Navigate, Build.', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDemoDataset(tester);

      await tester.pump(delay);

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost', BoostPanel);

      await tapChip(tester, 'Adaptive');

      await tapButton(tester, 'Build Boosted Trees');

      await tester.pump(delay);

      await gotoNextPage(tester);

      // Verify the content of the page.

      await verifyPage(
        'AdaBoost - Summary',
        'Final Confusion Matrix for Data:',
      );

      await gotoNextPage(tester);

      await tester.pump(interact);

      await gotoNextPage(tester);

      await tester.pump(interact);

      await verifyPage('Variable Importance');

      // Find a single ImagePage being displayed.

      await verifyImage(tester);
    });
  });
}
