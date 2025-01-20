import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/dataset/toggles.dart';
import 'package:rattle/providers/partition.dart';

Future<void> partitionOff(WidgetTester tester) async {
  final iconFinder = find.byIcon(Icons.horizontal_split);
  expect(iconFinder, findsOneWidget);

  // Get initial partition state
  final partitionState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(partitionProvider);

  // If partition is true, tap the icon to disable it
  if (partitionState) {
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();
  }

  // Verify partition is now disabled
  final updatedPartitionState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(partitionProvider);
  expect(updatedPartitionState, false);

  await tester.pumpAndSettle();
}
