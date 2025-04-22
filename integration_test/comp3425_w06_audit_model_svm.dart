/// COMP3425 W06 AUDIT -> SVM.
//
// Time-stamp: <Tuesday 2025-04-22 10:09:16 +1000 >
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
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_dataset_role.dart';
import 'utils/verify_selectable_text.dart';

/// Specific variables with ROLE set to 'Ignore'.

final List<String> varsToIgnore = ['accounts'];

final List<String> inputVars = [];

final String riskVar = 'adjustment';
final String targetVar = 'adjusted';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W06 AUDIT -> SVM:', () {
    testWidgets('verify.', (WidgetTester tester) async {
      app.main();

      // Load the dataset.

      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Audit');

      // Build a SVM with the defaults as on loading the dataset.

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'SVM');
      await tapButton(tester, 'Build SVM Model');

      await navigateToPage(tester, 1, title: 'SVM Model');
      await verifySelectableText(
        tester,
        [
          'Support Vector Machine object of class "ksvm"',
          'SV type: C-svc  (classification)',
          'parameter : cost C = 1',
          'Gaussian Radial Basis kernel function.',
          'Hyperparameter : sigma =  0.0977419863188865',
          'Number of Support Vectors : 416',
          'Objective Function Value : -201.4415',
          'Training error : 0.047177',
          'Probability model included.',
        ],
      );

      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await addDelay(tester, 25);
      await navigateToPage(tester, 1, back: 2, title: 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'Error matrix for the SVM model [TUNING] (counts)',
          'Predicted',
          'Actual  No Yes Error',
          'No  234   0   0.0',
          'Yes  18  48  27.3',
          'Error matrix for the SVM model [TUNING] (proportions)',
          'Predicted',
          'Actual No Yes Error',
          'No  78   0   0.0',
          'Yes  6  16  27.3',
          'Overall Error = 6.00%; Average Error = 13.64%.',
        ],
      );

      // Now more sensible dataset options and set variable roles.

      await navigateToTab(tester, 'Dataset');
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      for (final v in inputVars) {
        await verifyDatasetRole(v, 'Input');
      }
      await setDatasetRole(tester, riskVar, 'Risk');
      await setDatasetRole(tester, targetVar, 'Target');
      await verifyDatasetRole(targetVar, 'Target');
      await verifyDatasetRole('id', 'Ident');

      // Build svm.

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'SVM');
      await tapButton(tester, 'Build SVM Model');

      await navigateToPage(tester, 1, title: 'SVM Model');
      await verifySelectableText(
        tester,
        [
          'Support Vector Machine object of class "ksvm"',
          'SV type: C-svc  (classification)',
          'parameter : cost C = 1',
          'Gaussian Radial Basis kernel function.',
          'Hyperparameter : sigma =  0.118465362307129',
          'Number of Support Vectors : 585',
          'Objective Function Value : -446.3346',
          'Training error : 0.133434',
          'Probability model included.',
        ],
      );

      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await addDelay(tester, 20);
      await navigateToPage(tester, 1, back: 1, title: 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'Error matrix for the SVM model [TUNING] (counts)',
          'Predicted',
          'Actual  No Yes Error',
          'No  222  12   5.1',
          'Yes  32  34  48.5',
          'Error matrix for the SVM model [TUNING] (proportions)',
          'Predicted',
          'Actual   No  Yes Error',
          'No  74.0  4.0   5.1',
          'Yes 10.7 11.3  48.5',
          'Overall Error = 14.67%; Average Error = 26.81%.',
        ],
      );
    });
  });
}
