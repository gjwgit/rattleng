/// MEDICAL dataset MODEL tab TREE feature RPART option CONFIGURATIONS.
//
// Time-stamp: <Tuesday 2025-02-11 11:27:17 +1100 >
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/set_dataset_role.dart';
import 'utils/set_text_field.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';

/// List of specific variables that should have their role automatically set to
/// 'Ignore' in the DEMO and the LARGE datasets.

final List<String> varsToIgnore = [
  'first_name',
  'middle_name',
  'last_name',
  'birth_date',
  'street_address',
  'suburb',
  'postcode',
  'phone',
  'email',
  'clinical_notes',
  'consultation_timestamp',
];

// 20250206 gjw For this dataset rec_id, ssn, and medicare_number are all
// automatically identifiers. We then add a collection of Ignored variables and
// change the target to build a tree which only has a root node. Identifiers
// should be ignored in any modelling.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MEDICAL MODEL TREE RPART CONGIFURATION:', () {
    testWidgets('load, configure, build, test.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree', TreePanel);

      // 20250130 gjw Should put this into utils but currently it assumes a
      // single check box on this page so need to considere that. For now keep
      // it here procedurally rather than declaratively.

      final Finder includeMissingCheckbox = find.byType(Checkbox);
      await tester.tap(includeMissingCheckbox);
      await tester.pumpAndSettle();
      await setTextField(tester, 'minSplitField', '21');
      await setTextField(tester, 'maxDepthField', '29');
      await setTextField(tester, 'minBucketField', '9');
      await setTextField(tester, 'complexityField', '0.0110');
      await setTextField(tester, 'priorsField', '0.5,0.5');
      await setTextField(tester, 'lossMatrixField', '0,10,1,0');
      await tester.pump(interact);
      await tapButton(tester, 'Build Decision Tree');
      await gotoNextPage(tester);
      await verifyPage('Decision Tree Model', 'Observations = 14000');
      await gotoNextPage(tester);
      await gotoNextPage(tester);
      await verifyPage('Decision Tree as Rules');
      await tester.pump(interact);
    });
  });
}
