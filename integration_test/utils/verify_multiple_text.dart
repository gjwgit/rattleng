/// function to verify the text content in the widget
//
// Time-stamp: <Tuesday 2024-08-27 20:54:02 +0800 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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

Future<void> verifyMultipleTextContent(
  WidgetTester tester,
  List<String> values,
) async {
  for (final value in values) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsOneWidget);
  }
}
