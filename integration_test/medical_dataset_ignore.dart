/// Test MEDICAL dataset IGNORE roles.
//
// Time-stamp: <Thursday 2025-01-23 13:42:16 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/load_dataset_by_path.dart';
import 'utils/set_dataset_role.dart';

/// List of specific variables that should have their role automatically set to
/// 'Ignore' in the DEMO and the LARGE datasets.

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

  testWidgets('Medical Dataset Ignore Variables.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDatasetByPath(tester, 'integration_test/medical.csv');

    // TODO 20250123 gjw VERIFY ROLES

    // verifyRole('rec_id', 'Ident');
    // verifyRole('ssn', 'Ident');
    // verifyRole('gender', 'Target');

    for (final v in varsToIgnore) {
      await setDatasetRole(tester, v, 'Ignore');
    }

//    final random = Random();
//    String randomItem = varsToIgnore[random.nextInt(varsToIgnore.length)];

    // TODO 20250123 gjw VERIFY ROLES

    // verifyRole(randomItem, 'Ignore');
    // verifyRole('gender', 'Target');
  });
}
