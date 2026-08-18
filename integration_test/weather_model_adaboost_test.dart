/// Build BOOST model.
//
// Time-stamp: <Wednesday 2025-04-16 13:40:56 +1000 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_page.dart';
import 'utils/wait_for_r.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Model Boost Ada', () {
    testWidgets('Load, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester);
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost');
      await tapChip(tester, 'Adaptive');
      await tapButton(tester, 'Build Boosted Trees');
      await waitForR(tester);
      await gotoNextPage(tester);
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
