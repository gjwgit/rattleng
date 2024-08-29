// helper.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rattle/features/correlation/panel.dart';
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
