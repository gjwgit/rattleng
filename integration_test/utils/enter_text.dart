import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> enterText(WidgetTester tester, String key, String value) async {
  final textFieldFinder = find.byKey(Key(key));
  expect(textFieldFinder, findsOneWidget);
  await tester.enterText(textFieldFinder, value);
  await tester.pumpAndSettle();
}
