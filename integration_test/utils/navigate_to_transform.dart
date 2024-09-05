///  Navigate to the Transform tab.
//
// Time-stamp: <Tuesday 2024-09-03 09:05:26 +1000 Graham Williams>
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

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:rattle/tabs/transform.dart';

Future<void> navigateToTransformTab(WidgetTester tester) async {
  final transformIconFinder = find.byIcon(Icons.transform);
  expect(transformIconFinder, findsOneWidget);

  await tester.tap(transformIconFinder);
  await tester.pumpAndSettle();

  expect(find.byType(TransformTabs), findsOneWidget);
}
