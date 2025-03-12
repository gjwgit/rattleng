/// WEATHER dataset MODEL tab FOREST feature.
//
// Time-stamp: <Thursday 2025-03-13 07:12:59 +1100 Graham Williams>
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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

import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER MODEL RANDOM FOREST:', () {
    testWidgets('load, navigate, build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Forest', ForestPanel);
      await tapButton(tester, 'Build Random Forest');
      await navigateToPage(tester, 1, 'Random Forest Model');
      await gotoNextPage(tester, title: 'Sample Rules');
      await gotoNextPage(tester, title: 'Variable Importance — Numeric');
      await verifySelectableText(tester, ['humidity_3pm']);
      await gotoNextPage(tester, title: 'Variable Importance — Plot');
    });
  });
}
