import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> scrollDown(
  WidgetTester tester,
) async {
  // Find the first Scrollable widget and scroll to the bottom.

  await tester.fling(
    find.byType(Scrollable).first,
    // Scroll down with significant offset.

    const Offset(0, -1000),
    // Higher velocity for longer scroll.

    3000,
  );
}
