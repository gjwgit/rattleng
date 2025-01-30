import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

Future<void> setTextField(
  WidgetTester tester,
  String key,
  String value,
) async {
  await tester.enterText(find.byKey(Key(key)), value);
  await tester.pumpAndSettle();
}
