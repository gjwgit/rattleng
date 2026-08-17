/// Test the layout of the textual table of missing value patterns.
///
/// Time-stamp: "Sunday 2026-08-17 17:10:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER 2007 MISSING:', () {
    testWidgets('the pattern table reads down the variables.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // The 2007 weather dataset has missing values in several variables, and
      // so exercises the counts rather than reporting nothing missing.

      await loadDemoDataset(tester, '2007');
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Missing');
      await tapButton(tester, 'Perform Missing Analysis');
      await tester.pump(hack);
      await tester.pumpAndSettle();

      // Walk on to the Patterns of Missing Values page, which is the fourth
      // dot: the introduction, the two counts, then the patterns table.

      for (int page = 0; page < 3; page++) {
        await gotoNextPage(tester);
        await tester.pump(delay);
      }

      final Finder table = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SelectableText &&
            (widget.data ?? '').contains('Count of Observations'),
      );

      expect(table, findsWidgets);

      final String content =
          tester.widgetList<SelectableText>(table).first.data!;

      // The two counts are labelled and at the top, and the variables follow
      // one to a line. See `missing_pattern_table()` in
      // `assets/r/explore_missing.R`.

      final List<String> lines =
          content.split('\n').where((line) => line.trim().isNotEmpty).toList();

      expect(lines.first, startsWith('Count of Observations'));
      expect(lines[1], startsWith('Number Missing'));

      // A variable per line, each ending in its count of missing values.

      expect(lines[2], startsWith('date'));
      expect(
        lines.any((line) => line.startsWith('wind_dir_9am')),
        isTrue,
        reason: 'the variable with the most missing values is not listed',
      );

      // The table is not wrapped into blocks, which is the point of turning it
      // on its side, so no variable name appears twice.

      final Iterable<String> names = lines
          .skip(2)
          .map((line) => line.split(' ').first)
          .where((name) => name.isNotEmpty);

      expect(
        names.length,
        names.toSet().length,
        reason: 'a variable is listed twice, so the table has wrapped',
      );
    });
  });
}
