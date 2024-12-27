/// Load one of the DEMO datasets.
//
// Time-stamp: <Saturday 2024-12-28 06:23:43 +1100 Graham Williams>
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

/// Load the dataset and undertake basic tests that it loaded just fine.

Future<void> loadDemoDataset(
  WidgetTester tester, [
  String dataset = 'Weather',
]) async {
  testPrint('Open the ${dataset.toUpperCase()} Dataset.');

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

  final weatherButton = find.text(dataset);
  expect(weatherButton, findsOneWidget);

  await tester.tap(weatherButton);
  await tester.pumpAndSettle();

  await tester.pump(interact);

  // Expect to find the dataset filename in the path.

  final dsPathTextFinder = find.byKey(datasetPathKey);
  expect(dsPathTextFinder, findsOneWidget);
  final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
  String filename = dsPathText.controller?.text ?? '';
  expect(filename.contains('${dataset.toLowerCase()}.csv'), isTrue);

  // 20241019 gjw Add a delay here. Whilst app and dataset load.

  await tester.pump(delay);

  testPrint('Finished loading the ${dataset.toUpperCase()} Dataset.');
}
