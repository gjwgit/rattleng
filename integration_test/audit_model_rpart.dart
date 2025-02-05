/// COMP3425 AUDIT dataset MODEL tab TREE feature RPART option.
//
// Time-stamp: <Thursday 2025-02-06 09:37:09 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
//import 'package:rattle/widgets/image_page.dart';
//import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AUDIT MODEL TREE RPART:', () {
    testWidgets('set risk, build tree, verify.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Audit');
      // 20250131 gjw The test is sometimes failing with a `Could not find
      // 'adjustment'`. One delay was still sometimes not enough so make it two
      // delays for now. Perhaps the ROLES page is not yet ready sometimes.
      await tester.pump(delay);
      await tester.pump(delay);
      await setDatasetRole(tester, 'adjustment', 'Risk');
      await setDatasetRole(tester, 'marital', 'Ignore');
      await setDatasetRole(tester, 'education', 'Ignore');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree', TreePanel);
      await tapButton(tester, 'Build Decision Tree');
      await tester.pump(hack);
      await gotoNextPage(tester);
      await verifyPage('Decision Tree Model', 'Observations = 1400');
      await verifySelectableText(
        tester,
        [
          // 20250110 gjw We get a trivial decision tree initially since
          // adjustment is actually an output variable.

          '1) root 1400 319 No (0.77214286 0.22785714)',
          '2) age< 30.5 475  31 No (0.93473684 0.06526316) *',
          '14) gender=Female 118  28 No (0.76271186 0.23728814) *',
        ],
      );
    });
  });
}
