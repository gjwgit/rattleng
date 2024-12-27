/// Open the WEATHER dataset and test its contents.
//
// Time-stamp: <Friday 2024-12-27 14:44:59 +1100 Graham Williams>
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
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

import 'delays.dart';
import 'navigate_to_tab.dart';
import 'test_print.dart';
import 'verify_text.dart';

/// Open the WEATHER dataset and undertake basic tests that it loaded just fine.

Future<void> openWeatherDataset(WidgetTester tester) async {
  testPrint('Open the WEATHER Dataset.');

  // Ensure we are on the DATASET tab.

  await navigateToTab(tester, 'Dataset');

  final datasetButtonFinder = find.byType(DatasetButton);
  expect(datasetButtonFinder, findsOneWidget);

  await tester.tap(datasetButtonFinder);
  await tester.pumpAndSettle();

  // 20241014 gjw Without the following delay the test for the contents of the
  // ROLES page fails.

  await tester.pump(delay);

  final datasetPopup = find.byType(DatasetPopup);
  expect(datasetPopup, findsOneWidget);

  await tester.pump(interact);

  final weatherButton = find.text('Weather');
  expect(weatherButton, findsOneWidget);

  await tester.tap(weatherButton);
  await tester.pumpAndSettle();

  await tester.pump(interact);

  // Expect to find the WEATHER filename in the path.

  final dsPathTextFinder = find.byKey(datasetPathKey);
  expect(dsPathTextFinder, findsOneWidget);
  final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
  String filename = dsPathText.controller?.text ?? '';
  expect(filename.contains('weather.csv'), isTrue);

  testPrint('Check the ROLES page content for specific text.');

  // 20241019 gjw Add a delay here. Whilst app and weather_dataset and
  // weather_dataset_ignore loaded the dataset just fine, weather_explore failed
  // to find the text '2023-07-01'.

  await tester.pump(delay);

  // Expect specific text in the ROLES page.

  await verifyText(
    tester,
    [
      // Verify dates in the Content Column.

      '2023-07-01',
      '2023-07-02',

      // Verify min_temp in the Content Column.

      '4.6',

      // Verify max_temp in the Content Column.

      '13.9',
    ],
  );

  testPrint('Finished openning the WEATHER Dataset.');
}
