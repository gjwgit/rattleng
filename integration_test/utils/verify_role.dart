library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> verifyRole(String variable, String role) async {
  // Find the Text widget containing the variable name.

  final variableFinder = find.text(variable).first;

  // Find the parent Row widget that contains both variable name and role chips.

  final parentFinder = find.ancestor(
    of: variableFinder,
    matching: find.byType(Row),
  );

  // Verify that both variable and role exist.

  expect(variableFinder, findsOneWidget);
  // Verify that the role chip exists and is selected.

  final choiceChip = find
      .descendant(
        of: parentFinder.first,
        matching: find.byType(ChoiceChip),
      )
      .evaluate()
      .firstWhere(
        (element) =>
            element.widget is ChoiceChip &&
            (element.widget as ChoiceChip).label is Text &&
            ((element.widget as ChoiceChip).label as Text).data == role &&
            (element.widget as ChoiceChip).selected,
      );
  expect(choiceChip, isNotNull);
}
