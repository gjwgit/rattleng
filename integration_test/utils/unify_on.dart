import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/dataset/toggles.dart';
import 'package:rattle/providers/normalise.dart';

Future<void> unifyOn(WidgetTester tester) async {
  final iconFinder = find.byIcon(Icons.auto_fix_high_outlined);
  expect(iconFinder, findsOneWidget);

  // Get initial normalise state.

  final unifyState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(normaliseProvider);

  // If normalise is false, tap the icon to enable it.

  if (!unifyState) {
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();
  }

  // Verify normalise is now enabled.

  final updatedUnifyState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(normaliseProvider);
  expect(updatedUnifyState, true);

  await tester.pumpAndSettle();
}
