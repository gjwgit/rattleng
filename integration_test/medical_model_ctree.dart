/// Test the MODEL tab's TREE feature with the LARGE dataset.
//
// Time-stamp: <Monday 2025-05-19 16:13:43 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/number_field.dart';

import 'utils/add_delay.dart';
import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button_by_key.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Large Model Tree CTree:', () {
    testWidgets('Load, Navigate.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
      // TODO 20250519
      // INGNORE ALL
      // TARGET is smoking_status
      // INPUT is marital_status age_at_consultation
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree');
      await tapChip(tester, 'Conditional');
      // Don't build the tree with default parameters as it takes a long time.
      //
      // await tapButtonByKey(tester, 'Build Decision Tree');
      // await addDelay(tester, 60);
      // await gotoNextPage(tester);
      // await verifyPage('Decision Tree Model');
    });
  });
}
