/// WEATHER -> XGBOOST -> EVALUATE
//
// Time-stamp: <Tuesday 2025-03-25 13:02:11 +1100 Graham Williams>
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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
/// Authors:  Kevin Wang
library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';
import 'utils/wait_for_r.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER -> XGBOOST -> EVALUATE:', () {
    testWidgets('verify.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost');
      await tapButton(tester, 'Build Boosted Trees');

      // 20260818 gjw Wait for R to finish building before looking at the
      // summary it produces. See `utils/wait_for_r.dart`.

      await waitForR(tester);

      await navigateToPage(tester, 1, title: 'XGBoost - Summary', back: 1);
      // 20260818 gjw The table has four columns, not five. The `Importance`
      // column that used to appear was an accident of the old xgboost: the
      // importance plot is built from the same data.table and used to add that
      // column to it by reference, giving a duplicate of `Gain`. It no longer
      // does.
      //
      // The header and the ordering of the features are checked rather than the
      // numbers themselves, which move with every release of xgboost and would
      // have this test needing an edit each time without saying anything more
      // about whether Rattle works.

      await verifySelectableText(tester, [
        '          Feature        Gain       Cover   Frequency',
        '           <char>       <num>       <num>       <num>',
      ]);

      final String importance = tester
          .widgetList<SelectableText>(find.byType(SelectableText))
          .map((text) => text.data ?? '')
          .firstWhere((text) => text.contains('Feature'));

      final List<String> features = importance
          .split('\n')
          .where((line) => line.trim().startsWith(RegExp(r'[a-z]')))
          .map((line) => line.trim().split(' ').first)
          .toList();

      expect(
        features.take(2),
        ['humidity_3pm', 'pressure_3pm'],
        reason: 'the two most important features have changed',
      );
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await waitForR(tester);
      await navigateToPage(tester, 1, title: 'Error Matrix', back: 1);
      // 20260818 gjw One observation moved from correctly to incorrectly
      // predicted, so the counts here are no longer 11/3. The model is built by
      // xgboost 3, through its own interface rather than the pre-3 one that
      // rattle's `xgboost()` still uses, and a differently built model predicts
      // differently.

      await verifySelectableText(tester, [
        '   No  10   4  28.6',
        '   Yes  6   2  75.0',
        '   No  45.5 18.2  28.6',
        '   Yes 27.3  9.1  75.0',
        '',
        'Overall Error = 45.45%; Average Error = 51.79%.',
      ]);
    });
  });
}
