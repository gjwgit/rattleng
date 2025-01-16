import 'package:flutter_test/flutter_test.dart';

Future<void> tapChip(WidgetTester tester, String chipText) async {
  final chipFinder = find.text(chipText);
  expect(chipFinder, findsOneWidget);
  await tester.tap(chipFinder);
  await tester.pumpAndSettle();
}
