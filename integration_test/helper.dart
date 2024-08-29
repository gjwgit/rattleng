/// Helper functions for integration tests.
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
import 'package:flutter/material.dart';

// import 'package:rattle/features/correlation/panel.dart';
import 'package:rattle/tabs/explore.dart'; // Adjust imports as necessary

Future<void> verifyTextContent(WidgetTester tester, String? value) async {
  if (value != null) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsOneWidget);
  }
}

Future<void> verifyPageContent(WidgetTester tester, String title,
    [String? value]) async {
  final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(rightArrowFinder, findsOneWidget);

  await tester.tap(rightArrowFinder);
  await tester.pumpAndSettle();

  final titleFinder = find.textContaining(title);
  expect(titleFinder, findsOneWidget);

  if (value != null) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsOneWidget);
  }
}

Future<void> performCorrelationAnalysis(WidgetTester tester) async {
  final buttonFinder = find.text('Perform Correlation Analysis');
  expect(buttonFinder, findsOneWidget);

  await tester.tap(buttonFinder);
  await tester.pumpAndSettle();
}

Future<void> navigateToTab(
    WidgetTester tester, String tabTitle, Type panelType) async {
  final tabFinder = find.text(tabTitle);
  expect(tabFinder, findsOneWidget);

  await tester.tap(tabFinder);
  await tester.pumpAndSettle();

  expect(find.byType(panelType), findsOneWidget);
}

Future<void> navigateToExploreTab(WidgetTester tester) async {
  final exploreIconFinder = find.byIcon(Icons.insights);
  expect(exploreIconFinder, findsOneWidget);

  await tester.tap(exploreIconFinder);
  await tester.pumpAndSettle();

  expect(find.byType(ExploreTabs), findsOneWidget);
}
