/// Function goes to variableChooser widget and then selects the given
/// variable name.
//
// Time-stamp: <Saturday 2024-12-28 06:23:43 +1100 Graham Williams>
//
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
/// Authors: Kevin Wang
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> setSelectedVariable(
  WidgetTester tester,
  String variableName,
) async {
  expect(
    find.byWidgetPredicate(
      (widget) =>
          widget is DropdownMenu &&
          widget.label is Text &&
          (widget.label as Text).data == 'Variable',
    ),
    findsOneWidget,
    reason: 'Variable chooser dropdown not found',
  );

  await tester.tap(
    find.byWidgetPredicate(
      (widget) =>
          widget is DropdownMenu &&
          widget.label is Text &&
          (widget.label as Text).data == 'Variable',
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(variableName).last);
  await tester.pumpAndSettle();
}

Future<void> setSelectedVariable2(
  WidgetTester tester,
  String variableName,
) async {
  expect(
    find.byWidgetPredicate(
      (widget) =>
          widget is DropdownMenu &&
          widget.label is Text &&
          (widget.label as Text).data == 'Variable',
    ),
    findsOneWidget,
    reason: 'Variable chooser dropdown not found',
  );

  await tester.tap(
    find.byWidgetPredicate(
      (widget) =>
          widget is DropdownMenu &&
          widget.label is Text &&
          (widget.label as Text).data == 'Variable',
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(variableName).first);
  await tester.pumpAndSettle();
}
