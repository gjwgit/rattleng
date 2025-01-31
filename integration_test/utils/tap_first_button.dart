///  Tap the first button with the given label in case there could be multiple.
//
// Time-stamp: <Friday 2025-01-31 16:01:53 +1100 Graham Williams>
//
/// Copyright (C) 2023-2025, Togaware Pty Ltd
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

import 'package:flutter_test/flutter_test.dart';

Future<void> tapFirstButton(
  WidgetTester tester,
  String label,
) async {
  // Finds the first widget with the given text.

  final button = find.text(label).first;
  await tester.tap(button);
  await tester.pumpAndSettle();
}
