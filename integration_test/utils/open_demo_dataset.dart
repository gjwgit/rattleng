/// Tester support function to open the DEMO dataset.
//
// Time-stamp: <Tuesday 2024-09-10 15:59:58 +1000 Graham Williams>
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
/// Authors: Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

import 'delays.dart';

Future<void> openDemoDataset(WidgetTester tester) async {
  final datasetButtonFinder = find.byType(DatasetButton);
  expect(datasetButtonFinder, findsOneWidget);

  await tester.pump(pause);

  await tester.tap(datasetButtonFinder);
  await tester.pumpAndSettle();
  await tester.pump(delay);

  final datasetPopup = find.byType(DatasetPopup);
  expect(datasetPopup, findsOneWidget);

  await tester.pump(pause);

  // TODO 20240902 kev DETECT POPUP WARNING AND TAP YES
  //
  // If a dataset has already been loaded then a popup warning is
  // displayed. Here we need to identify if the popup is required (perhaps by
  // checking the appropriate provider and/or using the same test that triggers
  // the popup) where we need to then tap YES if the popup exists.

  // final resetDatasetButton = find.text('Yes');
  // await tester.tap(resetDatasetButton);
  // await tester.pumpAndSettle();
  // await tester.pump(delay);

  final demoButton = find.text('Demo');
  expect(demoButton, findsOneWidget);

  await tester.tap(demoButton);
  await tester.pumpAndSettle();

  await tester.pump(pause);
}
