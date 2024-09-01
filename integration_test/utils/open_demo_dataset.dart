import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/constants/delays.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

Future<void> openDemoDataset(WidgetTester tester) async {
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
