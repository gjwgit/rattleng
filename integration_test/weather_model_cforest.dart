/// WEATHER dataset MODEL tab FOREST feature CFOREST option.
//
// Time-stamp: <Wednesday 2025-02-12 07:55:10 +1100 >
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/forest/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER MODEL FOREST CFOREST:', () {
    testWidgets('build, test.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester);
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Forest', ForestPanel);
      await tester.pump(interact);
      await tapChip(tester, 'Conditional');
      await tapButton(tester, 'Build Random Forest');
      await tester.pump(delay);
      await gotoNextPage(tester);
      await verifyPage('Random Forest Model');
      await verifySelectableText(tester, [
        'Number of trees:  500',
        'Number of observations:  254',
      ]);
      await tester.pump(interact);
      await gotoNextPage(tester);
      // 20250212 gjw Oddly on one failure `0.025935...` was not found, yet
      // presumably `humidity_3pm` was found. Add a delay to see if this is
      // repeated.
      await tester.pump(delay);
      await verifySelectableText(tester, [
        'humidity_3pm',
        '0.0259354839',
      ]);
      await tester.pump(interact);
    });
  });
}
