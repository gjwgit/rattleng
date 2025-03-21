/// COMP3425 W06 AUDIT dataset MODEL tab SVM feature.
//
// Time-stamp: <Friday 2025-03-21 13:53:21 +1100 Graham Williams>
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

import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_dataset_role.dart';
import 'utils/set_partition.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_role.dart';
import 'utils/verify_selectable_text.dart';

/// Specific variables with ROLE set to 'Ignore'.

final List<String> varsToIgnore = [];

final List<String> inputVars = [];

final String riskVar = 'adjustment';
final String targetVar = 'adjusted';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W06 LAB AUDIT SVM:', () {
    testWidgets('roles, ignore, cleanup, impute, rescale, nnet.',
        (WidgetTester tester) async {
      app.main();

      // Load the dataset and set variable roles.

      await tester.pumpAndSettle();
      await setPartition(tester, true);
      await loadDemoDataset(tester, 'Audit');
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      for (final v in inputVars) {
        await verifyRole(v, 'Input');
      }
      await setDatasetRole(tester, riskVar, 'Risk');
      await setDatasetRole(tester, targetVar, 'Target');
      await verifyRole(targetVar, 'Target');
      await verifyRole('id', 'Ident');

      // Build svm.

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'SVM');
      await tapButton(tester, 'Build SVM Model');

      await navigateToPage(tester, 1, 'SVM Model');
      await verifySelectableText(
        tester,
        [
          'Gaussian Radial Basis kernel function.',
          'Hyperparameter : sigma =  0.10302200712113',
          'Number of Support Vectors : 569',
          'Objective Function Value : -438.7149',
          'Training error : 0.130704',
          'Probability model included.',
        ],
      );

      // build nnet and neuralnet??

// evaluate either!!!
    });
  });
}
