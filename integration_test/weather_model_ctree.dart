/// Model tree test with demo dataset.
//
// Time-stamp: <Friday 2025-01-24 09:16:59 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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
/// Authors: Zheyuan Xu, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
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

  testWidgets('ctree.', (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    await tester.pump(interact);

    await loadDemoDataset(tester);

    await tester.pump(hack);

    await navigateToTab(tester, 'Model');

    await navigateToFeature(tester, 'Tree', TreePanel);

    // Switch between traditional and conditional algorithms

    await tapChip(tester, 'Conditional');
    await tapChip(tester, 'Traditional');
    await tapChip(tester, 'Conditional');

    await tapButtonByKey(tester, 'Build Decision Tree');

    await tester.pump(hack);

    await gotoNextPage(tester);

    await verifyPage('Decision Tree Model');

    await tester.pump(interact);

    await gotoNextPage(tester);

    await verifyImage(tester);

    await tester.pump(interact);
  });
}
