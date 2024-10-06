/// Test and demonstrate the DATASET tab features with the DEMO dataset.
//
// Time-stamp: <2024-10-05 17:47:13 gjw>
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

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/verify_multiple_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Dataset:', () {
    testWidgets('Glimpse, Roles.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await openDemoDataset(tester);

      await tester.pump(hack);

      final dsPathTextFinder = find.byKey(datasetPathKey);
      expect(dsPathTextFinder, findsOneWidget);
      final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
      String filename = dsPathText.controller?.text ?? '';
      expect(filename.contains('weather.csv'), isTrue);

      // Tap the right arrow button to go to "Dataset Glimpse" page.

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

      await tester.pump(hack);

      await verifyMultipleTextContent(
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
