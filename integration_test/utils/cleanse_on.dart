import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/dataset/toggles.dart';
import 'package:rattle/providers/cleanse.dart';

Future<void> cleanseOn(WidgetTester tester) async {
  final iconFinder = find.byIcon(Icons.cleaning_services);
  expect(iconFinder, findsOneWidget);

  // Get initial cleanse state.

  final cleanseState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(cleanseProvider);

  // If cleanse is false, tap the icon to enable it.

  if (!cleanseState) {
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();
  }

  // Verify cleanse is now enabled.

  final updatedCleanseState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(cleanseProvider);
  expect(updatedCleanseState, true);

  await tester.pumpAndSettle();
}
