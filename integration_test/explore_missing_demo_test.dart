/// EXPLORE tab: Missing Demo Dataset Test.
//
// Time-stamp: <Friday 2024-08-30 10:55:04 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/missing/panel.dart';

import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/tabs/explore.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 5);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Demo Missing:', () {
    testWidgets('Basic.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await _openDemoDataset(tester);
      await _navigateToExploreTab(tester);

      await _navigateToTab(tester, 'Missing', MissingPanel);

      await _performMissingAnalysis(tester);
      await _verifyPageContent(tester, 'Patterns of Missing Data', '47');
      await _verifyPageContent(tester, 'Patterns of Missing Values');
      await _verifyPageContent(
        tester,
        'Aggregation of Missing Values - Textual',
        '31',
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

Future<void> _openDemoDataset(WidgetTester tester) async {
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
    expect(valueFinder, findsOneWidget);
  }
}
