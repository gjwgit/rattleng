import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';

Future<void> goToNextPage(WidgetTester tester) async {
  // Find the right arrow button in the PageIndicator.

  final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(rightArrowFinder, findsOneWidget);

  // Tap the right arrow button twice to go to the last page for variable role selection.

  await tester.tap(rightArrowFinder);
  await tester.pumpAndSettle();

  // Pause after screen change.

  await tester.pump(pause);
}
