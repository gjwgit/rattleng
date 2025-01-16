/// Test WEATHER dataset loads properly.
//
// Time-stamp: <Friday 2025-01-10 08:45:30 +1100 Graham Williams>
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
/// Authors: Graham Williams, Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/load_demo_dataset.dart';
import 'utils/press_unify_icon.dart';
import 'utils/verify_text.dart';
import 'utils/press_cleanse_icon.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Load Weather Dataset and test when cleanse is on.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await pressCleanseIconOn(tester);

    await loadDemoDataset(tester);

    // Verify dataset content.

    await verifyText(
      tester,
      [
        // Verify dates in the Sample Column for date Variable.

        '2023-07-01',
        '2023-07-02',

        // Verify min_temp in the Sample Column.

        '4.6',

        // Verify max_temp in the Content Column.

        '13.9',
      ],
    );

    await verifyTextMultiple(
      tester,
      [
        // Verify Unique Values for date Variable.

        '365',

        // Verify Unique Values for min_temp Variable.

        '192',

        // Verify Type Values for wind_speed_9am Variable.

        'fct',
      ],
    );
  });

  testWidgets('Load Weather Dataset and test when cleanse is off.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await pressCleanseIconOff(tester);

    await loadDemoDataset(tester);

    await verifyTextMultiple(
      tester,
      [
        // Verify Sample Values for location Variable.

        'Canberra',

        // Verify Type Values for wind_dir_9am Variable.

        'chr',
      ],
    );
  });

  testWidgets(
      'Load Weather Dataset and test when cleanse is on and unify is on.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await pressCleanseIconOn(tester);
    await pressUnifyIconOn(tester);

    await loadDemoDataset(tester);

    await verifyTextMultiple(
      tester,
      [
        // Verify the variables are in lowercase and separated by underscores.

        'min_temp',
      ],
    );
  });

  testWidgets(
      'Load Weather Dataset and test when cleanse is on and unify is off.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await pressCleanseIconOn(tester);
    await pressUnifyIconOff(tester);

    await loadDemoDataset(tester);

    await verifyTextMultiple(
      tester,
      [
        // Verify the variables are in uppercase and underscores are removed.

        'MinTemp',
      ],
    );
  });
}
