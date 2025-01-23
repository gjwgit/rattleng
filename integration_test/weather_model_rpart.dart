/// Model tree test with demo dataset.
//
// Time-stamp: <Friday 2025-01-24 09:16:10 +1100 Graham Williams>
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
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('rpart.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.pump(interact);

    await loadDemoDataset(tester);

    // await tester.pump(hack);

    await navigateToTab(tester, 'Model');

    await navigateToFeature(tester, 'Tree', TreePanel);

    await verifyMarkdown(tester);

    // Simulate the presence of a decision tree being built.

    await tapButtonByKey(tester, 'Build Decision Tree');

    // await tester.pump(hack);

    await gotoNextPage(tester);

    // Try tapping again as it may not have gone to the second page.

    // await tester.pump(hack);

    await verifyPage('Decision Tree Model');

    // App may raise bugs in loading textPage. Thus, test does not target
    // at content.

    await verifyExist(TextPage);

    await tester.pump(interact);

    // Tap the right arrow to go to the third page.

    await gotoNextPage(tester);
    await gotoNextPage(tester);

    await verifyPage('Decision Tree as Rules');

    // App may raise bugs in loading textPage. Thus, test does not target
    // at content.

    await verifyExist(TextPage);

    await tester.pump(interact);
  });
}
