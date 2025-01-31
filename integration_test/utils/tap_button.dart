/// Tap an activity (build) button with the corresponding label.
//
// Time-stamp: <Thursday 2025-01-30 16:38:45 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

/// Tap an [ElevatedButton] with the [text] label.

Future<void> tapButton(
  WidgetTester tester,
  String text,
) async {
  final button = find.byWidgetPredicate(
    (Widget widget) =>
        widget is ElevatedButton &&
        widget.child is Text &&
        (widget.child as Text).data == text,
  );
  expect(button, findsOneWidget);

  await tester.tap(button);
  await tester.pumpAndSettle();
}
