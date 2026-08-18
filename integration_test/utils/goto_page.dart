/// Show the page with a given title, wherever it happens to be.
//
// Time-stamp: <Wednesday 2026-08-19 09:30:00 +1000 Graham Williams>
//
/// Copyright (C) 2026, Togaware Pty Ltd
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/widgets/page_indicator.dart';

/// Show the page whose title contains [title], from wherever we are now.
///
/// Counting arrow taps to reach a page assumes we know which page we are on to
/// begin with, and that assumption does not hold. `PageViewer` keeps the
/// current page in its own state, starting at 0, and nothing reconciles that
/// with the pages when R adds to them, so a panel that has just rebuilt can be
/// showing one page while the arrows think it is on another. A test that taps
/// forward twice from there lands somewhere unintended, and the failure reads
/// as the page content being wrong rather than as the test having got lost.
///
/// So ask for the page by name. This rewinds to the first page and steps
/// forward until the title shows up, which is the same wherever it started.
///
/// The number of pages comes from the page indicator, so the walk is bounded by
/// the panel itself. If the title is nowhere among them the failure says so,
/// rather than leaving a bare "Found 0 widgets" for the caller to puzzle over.

Future<void> gotoPage(WidgetTester tester, String title) async {
  final Finder wanted = find.textContaining(title);

  // Already showing, so leave the pages as they are.

  if (wanted.evaluate().isNotEmpty) return;

  final Finder indicatorFinder = find.byType(NewPageIndicator);

  if (indicatorFinder.evaluate().isEmpty) {
    fail('Looking for the page "$title" but this panel has no pages.');
  }

  final int pages = tester.widget<NewPageIndicator>(indicatorFinder).numOfPages;

  final Finder back = find.byIcon(Icons.arrow_left_rounded);
  final Finder forward = find.byIcon(Icons.arrow_right_rounded);

  // Rewind to the first page. Tapping back on the first page does nothing, so
  // a tap per page is always enough and never too many.

  for (int i = 0; i < pages; i++) {
    await tester.tap(back);
    await tester.pumpAndSettle();
  }

  if (wanted.evaluate().isNotEmpty) return;

  for (int i = 1; i < pages; i++) {
    await tester.tap(forward);
    await tester.pumpAndSettle();

    if (wanted.evaluate().isNotEmpty) return;
  }

  fail('No page titled "$title" among the $pages pages of this panel.');
}
