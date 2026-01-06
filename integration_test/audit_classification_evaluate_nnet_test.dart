/// AUDIT -> TRANSFORM -> MODEL -> NEURAL -> EVALUATE -> ERROR MATRIX
//
// Time-stamp: <Thursday 2025-05-01 09:43:44 +1000 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/set_selected_variable.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/tap_popup.dart';
import 'utils/verify_dataset_role.dart';
import 'utils/verify_selectable_text.dart';

/// Specific variables with ROLE set to 'Ignore'.

final List<String> varsToIgnore = [
  'employment',
  'education',
  'marital',
  'occupation',
  'gender',
  'accounts',
];

final List<String> inputVars = ['age', 'income', 'deductions', 'hours'];

final String riskVar = 'adjustment';
final String targetVar = 'adjusted';
final String idVar = 'id';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AUDIT -> TRANSFORM -> MODEL -> NEURAL -> EVALUATE:', () {
    testWidgets('ignore, rescale, configure, evaluate, error matrix.', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // DATASET -> AUDIT -> ROLES

      await loadDemoDataset(tester, 'Audit');
      await addDelay(tester, 1);
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      for (final v in varsToIgnore) {
        await verifyDatasetRole(v, 'Ignore');
      }
      for (final v in inputVars) {
        await verifyDatasetRole(v, 'Input');
      }
      await setDatasetRole(tester, riskVar, 'Risk');
      await verifyDatasetRole(targetVar, 'Target');
      await verifyDatasetRole(idVar, 'Ident');

      // TRANSFORM -> RESCALE

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Rescale');
      await tapChip(tester, 'Scale [0-1]');
      for (final v in inputVars) {
        await setSelectedVariable(tester, v);
        await tapButton(tester, 'Rescale Variable Values');
      }
      await navigateToFeature(tester, 'Cleanup');
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');
      await tapPopup(tester, 'Yes');

      // MODEL -> CONFIGURE -> NNET

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Neural');
      await tapButton(tester, 'Build Neural Network');
      await navigateToPage(
        tester,
        1,
        back: 1,
        title: 'Neural Net Model - Summary and Weights',
      );
      await verifySelectableText(tester, [
        'A 4-10-1 network with 65 weights',
        'Inputs: R01_age, R01_income, R01_deductions, R01_hours,',
        'b->h1 i1->h1 i2->h1 i3->h1 i4->h1',
        ' 1.12  11.16  -0.64  15.49   2.91',
      ]);

      // EVALUATE -> ERROR MATRIX

      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await navigateToPage(tester, 1, back: 2, title: 'Error Matrix');
      await verifySelectableText(tester, [
        'No  220  14   6.0',
        'Yes  52  14  78.8',
        'No  73.3 4.7   6.0',
        'Yes 17.3 4.7  78.8',
        'Overall Error = 22.00%; Average Error = 42.39%.',
      ]);
    });
  });
}
