/// AUDIT -> CLASSIFICATION -> TRANSFORM -> MODEL -> NEURALNET -> EVALUATE -> ERROR MATRIX
//
// Time-stamp: <Thursday 2025-04-03 18:35:44 +1100 >
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

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/set_selected_variable.dart';
import 'utils/set_text_field.dart';
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'AUDIT -> CLASSIFICATION -> TRANSFORM -> MODEL -> NEURALNET -> EVALUATE:',
    () {
      testWidgets('ignore, rescale, evaluate, error matrix.', (
        WidgetTester tester,
      ) async {
        app.main();
        await tester.pumpAndSettle();
        await tester.pump(interact);

        // DATASET -> AUDIT -> ROLES

        await loadDemoDataset(tester, 'Audit');
        for (final v in varsToIgnore) {
          await setDatasetRole(tester, v, 'Ignore');
        }
        for (final v in inputVars) {
          await verifyDatasetRole(v, 'Input');
        }
        await setDatasetRole(tester, riskVar, 'Risk');
        await verifyDatasetRole(targetVar, 'Target');
        await verifyDatasetRole('id', 'Ident');

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
        await addDelay(tester, 4);

        // MODEL -> CONFIGURE -> NNET

        await navigateToTab(tester, 'Model');
        await navigateToFeature(tester, 'Neural');
        await tapChip(tester, 'neuralnet');
        await setTextField(tester, 'neuralnet_config_hidden_layers', '3,2');
        await tapButton(tester, 'Build Neural Network');
        await addDelay(tester, 4);
        await navigateToPage(
          tester,
          1,
          back: 1,
          title: 'Neural Net Model - Summary and Weights',
        );
        await verifySelectableText(tester, [
          'Error                       9.509195e+01',
          'Reached.threshold           7.498733e-03',
          'Steps                       1.195300e+04',
          'Intercept.to.1layhid1       9.169849e-01',
          'R01_age.to.1layhid1        -2.139192e+00',
        ]);

        // EVALUATE -> ERROR MATRIX

        await navigateToTab(tester, 'Evaluate');
        await tapButton(tester, 'Evaluate');
        await addDelay(tester, 4);
        await navigateToPage(tester, 1, back: 1, title: 'Error Matrix');
        await verifySelectableText(tester, [
          // This seems wrong - need to check the pred function again. (gjw
          // 20250324)
          'No  234   0     0',
          'Yes  66   0   100',
          'No  78   0     0',
          'Yes 22   0   100',
          'Overall Error = 22.00%; Average Error = 50.00%.',
        ]);
      });
    },
  );
}
