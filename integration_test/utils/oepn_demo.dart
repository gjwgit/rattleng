/// Open the demo dataset.
//
// Time-stamp: <Tuesday 2024-08-27 20:54:02 +0800 Graham Williams>
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
/// Authors: Kevin Wang
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 5);

Future<void> openDemoDataset(WidgetTester tester) async {
  final datasetButtonFinder = find.byType(DatasetButton);
  expect(datasetButtonFinder, findsOneWidget);
  await tester.pump(pause);

  await tester.tap(datasetButtonFinder);
  await tester.pumpAndSettle();

  await tester.pump(delay);

  final datasetPopup = find.byType(DatasetPopup);
  expect(datasetPopup, findsOneWidget);
  final demoButton = find.text('Demo');
  expect(demoButton, findsOneWidget);
  await tester.tap(demoButton);
  await tester.pumpAndSettle();
  await tester.pump(pause);
}
