/// Test MEDICAL dataset IGNORE roles.
//
// Time-stamp: <Friday 2025-03-07 11:39:58 +1100 Graham Williams>
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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
/// Authors: Zheyuan Xu

library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/load_dataset_by_path.dart';
import 'utils/set_dataset_role.dart';
import 'utils/verify_dataset_role.dart';

/// Specific variables with ROLE set to 'Ignore'.

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
    await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
    verifyDatasetRole('rec_id', 'Ident');
    verifyDatasetRole('ssn', 'Ident');
    verifyDatasetRole('gender', 'Target');
    for (final v in varsToIgnore) {
      await setDatasetRole(tester, v, 'Ignore');
    }
    final random = Random();
    String randomItem = varsToIgnore[random.nextInt(varsToIgnore.length)];
    verifyDatasetRole(randomItem, 'Ignore');
    verifyDatasetRole('gender', 'Target');
  });
}
