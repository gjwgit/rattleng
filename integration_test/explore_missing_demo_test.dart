/// Test the EXPLORE tab's MISSING feature with the DEMO dataset.
//
// Time-stamp: <Monday 2024-09-02 10:32:09 +1000 Graham Williams>
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
/// Authors:  Kevin Wang, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/missing/panel.dart';

import 'utils/delays.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/explore.dart';

import 'utils/open_demo_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Explore Missing:', () {
    testWidgets('basic.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDemoDataset(tester);
      await _navigateToExploreTab(tester);

      await _navigateToTab(tester, 'Missing', MissingPanel);

      await _performMissingAnalysis(tester);
      await _verifyPageContent(tester, 'Patterns of Missing Data', '354');
      await _verifyPageContent(tester, 'Patterns of Missing Values');
      await _verifyPageContent(
        tester,
        'Aggregation of Missing Values - Textual',
        '7',
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

Future<void> _navigateToExploreTab(WidgetTester tester) async {
  final exploreIconFinder = find.byIcon(Icons.insights);
  expect(exploreIconFinder, findsOneWidget);

  await tester.tap(exploreIconFinder);
  await tester.pumpAndSettle();

  expect(find.byType(ExploreTabs), findsOneWidget);
}

Future<void> _navigateToTab(
  WidgetTester tester,
  String tabTitle,
  Type panelType,
) async {
  final tabFinder = find.text(tabTitle);
  expect(tabFinder, findsOneWidget);

  await tester.tap(tabFinder);
  await tester.pumpAndSettle();

  await tester.pump(pause);

  expect(find.byType(panelType), findsOneWidget);
}

Future<void> _performMissingAnalysis(WidgetTester tester) async {
  final generateSummaryButtonFinder = find.text('Perform Missing Analysis');
  expect(generateSummaryButtonFinder, findsOneWidget);

  await tester.tap(generateSummaryButtonFinder);
  await tester.pumpAndSettle();

  await tester.pump(pause);
  await tester.pump(delay);
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

  await tester.pump(pause);

  final titleFinder = find.textContaining(title);
  expect(titleFinder, findsOneWidget);

  if (value != null) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsWidgets);
  }
}
