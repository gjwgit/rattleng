/// WEATHER dataset MODEL FOREST EVALUATE feature.
//
// Time-stamp: <Saturday 2025-02-08 19:41:40 +1100 Graham Williams>
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
/// Authors:  Kevin Wang
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
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER MODEL FOREST EVALUATE:', () {
    testWidgets('build, evaluate, verify.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Forest', ForestPanel);
      await tapButton(tester, 'Build Random Forest');
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      // 20250208 gjw Sometimes, on ecosysl with the full test suite, this was
      // failing. Seems like because it is already on the next page and
      // sometimes not. We capture that issue here.
      try {
        await verifyPage('Error Matrix');
      } catch (e) {
        await gotoNextPage(tester);
        await verifyPage('Error Matrix');
      }
      await verifySelectableText(
        tester,
        [
          'No  13   1   7.1',
          'Yes  5   3  62.5',
          'No  59.1  4.5   7.1',
          'Yes 22.7 13.6  62.5',
          'Overall Error = 27.27%; Average Error = 34.82%.',
        ],
      );
    });
  });
}
