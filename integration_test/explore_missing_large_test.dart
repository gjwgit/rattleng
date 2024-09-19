/// Test the EXPLORE tab MISSING feature with th LARGE dataset.
//
// Time-stamp: <Friday 2024-09-20 08:44:08 +1000 Graham Williams>
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
/// Authors:  Kevin Wang

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/missing/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_dataset_by_path.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Tab:', () {
    testWidgets('Large Dataset, Explore, Missing.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDatasetByPath(tester, 'integration_test/rattle_test_large.csv');
      await navigateToTab(tester, 'Explore');

      await navigateToFeature(tester, 'Missing', MissingPanel);

      await _performMissingAnalysis(tester);
      await _verifyPageContent(tester, 'Patterns of Missing Data', '5955');
      await _verifyPageContent(tester, 'Patterns of Missing Values');
      await _verifyPageContent(
        tester,
        'Aggregation of Missing Values - Textual',
        '8137',
      );
      await _verifyPageContent(
        tester,
        'Aggregation of Missing Values - Visual',
      );
      await _verifyPageContent(
        tester,
        'Visualisation of Observations with Missing Values',
      );
      await _verifyPageContent(
        tester,
        'Comparison of Counts of Missing Values',
      );
      await _verifyPageContent(tester, 'Patterns of Missingness');
    });
  });
}

Future<void> _performMissingAnalysis(WidgetTester tester) async {
  final generateSummaryButtonFinder = find.text('Perform Missing Analysis');
  expect(generateSummaryButtonFinder, findsOneWidget);

  await tester.tap(generateSummaryButtonFinder);
  await tester.pumpAndSettle();

  await tester.pump(pause);
  await tester.pump(hack);
}

Future<void> _verifyPageContent(
  WidgetTester tester,
  String title, [
  String? value,
]) async {
  final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(rightArrowFinder, findsOneWidget);

  await tester.tap(rightArrowFinder);
  await tester.pumpAndSettle();

  await tester.pump(hack);

  final titleFinder = find.textContaining(title);
  expect(titleFinder, findsOneWidget);

  if (value != null) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsOneWidget);
  }
}
