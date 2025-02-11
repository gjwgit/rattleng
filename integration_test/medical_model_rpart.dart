/// MEDICAL dataset MODEL tab TREE feature RPART option.
//
// Time-stamp: <Thursday 2025-02-06 21:37:46 +1100 Graham Williams>
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
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_role.dart';
import 'utils/verify_selectable_text.dart';

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
    testWidgets('load, build, test.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
      await setDatasetRole(tester, 'smoking_status', 'Target');
      // 20250206 gjw gender is the default Target but after setting Target above
      // it should now be Input.
      await verifyRole('gender', 'Input');
      await verifyRole('rec_id', 'Ident');
      await verifyRole('ssn', 'Ident');
      await verifyRole('medicare_number', 'Ident');
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree', TreePanel);
      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);
      await tapButton(tester, 'Build Decision Tree');
      // 20250203 gjw Had to add three delays on ecosysl to await the
      // model to be built.
      await tester.pump(delay);
      await tester.pump(delay);
      await tester.pump(delay);
      await gotoNextPage(tester);
      // 20250203 gjw Needed another delay on ecosysl after going to
      // the next page.
      await tester.pump(delay);
      await verifyPage('Decision Tree Model');
      await verifySelectableText(
        tester,
        [
          '1) root 14000 1860 0 (0.8671429 0.1328571) *',
        ],
      );
      await tester.pump(interact);
    });
  });
}
