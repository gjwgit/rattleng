/// DATASET feature.
//
// Time-stamp: <Sunday 2025-01-26 08:56:59 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

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
    testWidgets('load weather; cancel load; load medical file.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
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
      final datasetButton = find.byType(DatasetButton);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      final resetDatasetButton = find.text('Yes');
      await tester.tap(resetDatasetButton);
      await tester.pumpAndSettle();

      final cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Locate the TextField where the file path is input.

      final filePathField = find.byType(TextField);
      await tester.enterText(filePathField, 'integration_test/medical.csv');

      // Simulate pressing the Enter key.

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // 20240901 gjw A hack to allow time for the dataset to be loaded before
      // progressing with the GUI. This is a rattle bug to be fixed - async of R
      // scripts issue. But even with this the PAGEs do not get re-rendered -
      // except by going to another feature and back again. Thus we get in the
      // qtest a undefined ds. As long as we pause, we do get the Dataset
      // Glimpse page.

      await tester.pump(hack);

      await verifySelectableText(
        tester,
        [
          // Verify the first couple of rec_id values.

          'rec-57600',
          'rec-73378',

          // Verify the first ssn.

          'i145245676',

          // Verify first middle name.

          'joseirizarry',
        ],
      );

      await tester.pump(interact);
    });
  });
}
