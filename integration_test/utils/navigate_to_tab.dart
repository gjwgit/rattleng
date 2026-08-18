/// Navigate to a tab in the app.
//
// Time-stamp: <Tuesday 2024-09-10 15:56:45 +1000 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/home.dart';

import 'wait_for_r.dart';

Future<void> navigateToTab(WidgetTester tester, String tabTitle) async {
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

  // 20260818 gjw Wait for R rather than for a fixed 2s. Leaving DATASET or
  // TRANSFORM re-sources the dataset template, so a tab change is often an R
  // job, and what the tab is showing is not right until that has finished.
  //
  // The GUI settle after tapping a feature within a tab is a different thing
  // and stays a plain delay -- see `navigate_to_feature.dart`.

  await waitForR(tester);
}
