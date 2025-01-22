import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/dataset/toggles.dart';
import 'package:rattle/providers/normalise.dart';

Future<void> unifyOff(WidgetTester tester) async {
  final iconFinder = find.byIcon(Icons.auto_fix_high_outlined);
  expect(iconFinder, findsOneWidget);

  // Get initial normalise state.

  final unifyState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(normaliseProvider);

  // If normalise is true, tap the icon to disable it.

  if (unifyState) {
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();
  }

  // Verify normalise is now disabled.

  final updatedUnifyState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(normaliseProvider);
  expect(updatedUnifyState, false);

  await tester.pumpAndSettle();
}
