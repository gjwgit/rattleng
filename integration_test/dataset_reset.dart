/// DATASET feature RESET function.
//
// Time-stamp: <Sunday 2025-01-26 08:58:11 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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

import 'utils/delays.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/main.dart' as app;

import 'utils/load_demo_dataset.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DATASET RESET:', () {
    testWidgets('load weather; reload weather; validate contents.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester);

      // 20250126 gjw Now reload the Weather dataset. We don't use
      // loadDemoDataset() since it does not handle the popup warning where we
      // need to tap YES.

      final datasetButtonFinder = find.byType(DatasetButton);
      await tester.tap(datasetButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      final resetDatasetButton = find.text('Yes');
      await tester.tap(resetDatasetButton);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      final demoButton = find.text('Weather');
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      await verifySelectableText(
        tester,
        [
          // Verify date in the Content Column.
          '2023-07-01',
          '2023-07-02',

          // Verify min_temp in the Content Column.
          '4.6',

          // Verify max_temp in the Content Column.
          '13.9',
        ],
      );
    });
  });
}
