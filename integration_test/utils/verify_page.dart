/// Verify the content of the page.
//
// Time-stamp: <Friday 2025-01-10 08:26:05 +1100 Graham Williams>
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

import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/widgets/image_page.dart';

/// Check that the expected title for the page is found and optionally some text
/// value on the page can be found.

Future<void> verifyPage(
  String title, [
  String? value,
]) async {
  final titleFinder = find.textContaining(title);
  expect(titleFinder, findsOneWidget);

  if (value != null) {
    final valueFinder = find.textContaining(value);
    expect(valueFinder, findsOneWidget);
  }
}

Future<void> verifyImage(WidgetTester tester) async {
  final imageFinder = find.byType(ImagePage);
  expect(imageFinder, findsOneWidget);
}
