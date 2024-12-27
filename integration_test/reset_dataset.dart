/// Test the DATASET RESET functionality.
//
// Time-stamp: <Monday 2024-10-14 13:34:37 +1100 Graham Williams>
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

import 'utils/open_weather_dataset.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dataset Reset:', () {
    testWidgets('demo navigate.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openWeatherDataset(tester);

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);

      // Tap the right arrow button to go to the second page.

      // await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // Tap the right arrow button to go to the third page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // Reload Demo Dataset. Not using openWeatherDataset() for now since it does
      // not handle the popup warning where we need to tap YES.

      final datasetButtonFinder = find.byType(DatasetButton);
      await tester.tap(datasetButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Handle the reset popup warning.

      final resetDatasetButton = find.text('Yes');
      await tester.tap(resetDatasetButton);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      final demoButton = find.text('Demo');
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // // Tap the right arrow button to go to "Dataset Glimpse" page.

      // await tester.tap(rightArrowFinder);
      // await tester.pumpAndSettle();
      // await tester.pump(interact);

      // // Find the text containing "366".

      // final glimpseRowFinder = find.textContaining('366');
      // expect(glimpseRowFinder, findsOneWidget);

      // // Find the text containing "2007-11-01".

      // final glimpseDateFinder = find.textContaining('2007-11-01');
      // expect(glimpseDateFinder, findsOneWidget);

      // Tap the right arrow button to go to "ROLES" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await verifyText(
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

    testWidgets('demo then large navigate', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openWeatherDataset(tester);

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);

      // Tap the right arrow button to go to the second page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // Tap the right arrow button to go to the third page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // Reload large dataset.

      final datasetButton = find.byType(DatasetButton);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

//      await tester.pump(hack);

      final resetDatasetButton = find.text('Yes');
      await tester.tap(resetDatasetButton);
      await tester.pumpAndSettle();

//      await tester.pump(hack);

      final cancelButton = find.text('Cancel');

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

//      await tester.pump(hack);

      // Locate the TextField where the file path is input.

      final filePathField = find.byType(TextField);

      // Enter the file path programmatically.

      await tester.enterText(
        filePathField,
        'integration_test/medical.csv',
      );

      // Simulate pressing the Enter key.

      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Optionally pump the widget tree to reflect the changes.

      await tester.pumpAndSettle();
      await tester.pump(interact);

      // 20240901 gjw A hack to allow time for the dataset to be loaded before
      // progressing with the GUI. This is a rattle bug to be fixed - async of R
      // scripts issue. But even with this the PAGEs do not get re-rendered -
      // except by going to another feature and back again. Thus we get in the
      // qtest a undefined ds. As long as we pause, we do get the Dataset
      // Glimpse page.

      await tester.pump(hack);

      // Find the right arrow button in the PageIndicator.

      expect(rightArrowFinder, findsOneWidget);

      // // Tap the right arrow button to go to the second page.

      // await tester.tap(rightArrowFinder);
      // await tester.pumpAndSettle();

      // await tester.pump(interact);

      // final glimpseRowFinder = find.textContaining('Dataset Glimpse');
      // expect(glimpseRowFinder, findsOneWidget);

      // // TODO 20240901 zy This is failing at present. See #378.

      // final datasetTextFinder = find.textContaining('Rows: 20,000');
      // expect(datasetTextFinder, findsOneWidget);

      // Tap the right arrow button to go to the third page.

      // await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(interact);
    });
  });
}
