import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> scrollUntilFindKey(WidgetTester tester, String key) async {
  await tester.scrollUntilVisible(
    find.byKey(PageStorageKey(key)),
    500.0,
    scrollable: find.byType(Scrollable).first,
  );
}
