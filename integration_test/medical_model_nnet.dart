/// Model NNET test with large dataset.
//
// Time-stamp: <Friday 2025-01-24 08:51:47 +1100 Graham Williams>
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/neural/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

/// List of specific variables that should have their role set to 'Ignore' in
/// the medical dataset. These are factors and don't play well with nnet.

final List<String> varsToIgnore = [
  'rec_id',
  'ssn',
  'first_name',
  'middle_name',
  'last_name',
  'birth_date',
  'medicare_number',
  'street_address',
  'suburb',
  'postcode',
  'phone',
  'email',
  'clinical_notes',
  'consultation_timestamp',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDatasetByPath(tester, 'integration_test/medical.csv');

    for (final v in varsToIgnore) {
      await setDatasetRole(tester, v, 'Ignore');
    }

    await navigateToTab(tester, 'Model');
    await navigateToFeature(tester, 'Neural', NeuralPanel);
    await tapButton(tester, 'Build Neural Network');
    await tester.pump(delay);

    await gotoNextPage(tester);
    await verifyPage('Neural Net Model - Summary and Weights');

    await verifySelectableText(
      tester,
      [
        'Options were - entropy fitting',
      ],
    );
  });
}
