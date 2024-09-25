/// Navigate to a tab in the app.
//
// Time-stamp: <Tuesday 2024-09-10 15:56:45 +1000 Graham Williams>
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

import 'package:rattle/home.dart';

import 'delays.dart';

Future<void> navigateToTab(
  WidgetTester tester,
  String tabTitle,
) async {
  // Find the tab details from homeTabs list using the tabTitle.

  final tab = homeTabs.firstWhere(
    (element) => element['title'] == tabTitle,
    orElse: () => throw Exception('Unknown tab title: $tabTitle'),
  );

  // Find the icon associated with the tab.

  final iconFinder = find.byIcon(tab['icon']);
  expect(iconFinder, findsOneWidget);

  // Tap the icon to navigate.

  await tester.tap(iconFinder);
  await tester.pumpAndSettle();

  await tester.pump(delay);
}
