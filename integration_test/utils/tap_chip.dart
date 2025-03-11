/// Utility to find a chip with the given label and tap it.
///
// Time-stamp: <Wednesday 2025-03-12 10:13:21 +1100 Graham Williams>
///
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

class NoChipFoundException implements Exception {
  final String message;
  NoChipFoundException(this.message);

  @override
  String toString() => 'No chip found by this name: "$message"';
}

/// Find a [Chip] widget with label [text] and tap it.

Future<void> tapChip(
  WidgetTester tester,
  String text,
) async {
  final chip = find.byWidgetPredicate(
    (Widget widget) =>
        widget is ChoiceChip && (widget.label as Text).data == text,
  );
  try {
    expect(chip, findsOneWidget);
  } catch (e) {
    throw NoChipFoundException(text);
  }
  await tester.tap(chip);
  await tester.pumpAndSettle();
}
