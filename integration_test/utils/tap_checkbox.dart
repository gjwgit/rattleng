import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tapCheckbox(WidgetTester tester, String key) async {
  final checkboxFinder = find.byKey(Key(key));
  expect(checkboxFinder, findsOneWidget);
  await tester.tap(checkboxFinder);
  await tester.pumpAndSettle();
}
