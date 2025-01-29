<<<<<<<< HEAD:integration_test/utils/scroll_until_find_key.dart
///  Fuction to scroll until a widget with a specific key is visible.
//
// Time-stamp: <Saturday 2024-12-28 06:23:43 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
========
///  Tap the first button with the given label in case there could be multiple.
//
// Time-stamp: <Thursday 2025-01-30 08:17:33 +1100 Graham Williams>
//
/// Copyright (C) 2023-2025, Togaware Pty Ltd
>>>>>>>> 811679e6 (Trying to repair the PR!!!!):integration_test/utils/tap_first_button.dart
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

<<<<<<<< HEAD:integration_test/utils/scroll_until_find_key.dart
/// Scroll until a widget with a specific key is visible.

Future<void> scrollUntilFindKey(WidgetTester tester, String key) async {
  await tester.scrollUntilVisible(
    find.byKey(PageStorageKey(key)),
    500.0,
    scrollable: find.byType(Scrollable).first,
  );
========
Future<void> tapFirstButton(
  WidgetTester tester,
  String label,
) async {
  // Finds the first widget with the given text.

  final button = find.text(label).first;
  await tester.tap(button);
  await tester.pumpAndSettle();
>>>>>>>> 811679e6 (Trying to repair the PR!!!!):integration_test/utils/tap_first_button.dart
}
