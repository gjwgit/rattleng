/// Move to and verify the content of the next page.
//
// Time-stamp: <Monday 2024-09-02 18:50:45 +1000 Graham Williams>
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
/// Authors: Kevin Wang

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'delays.dart';

Future<void> verifyPageContent(
  WidgetTester tester,
  String title, [
  String? value,
]) async {
  final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(rightArrowFinder, findsOneWidget);

  await tester.tap(rightArrowFinder);
  await tester.pumpAndSettle();

  await tester.pump(pause);

  final titleFinder = find.textContaining(title);
  expect(titleFinder, findsOneWidget);

  if (value != null) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsOneWidget);
  }
}
