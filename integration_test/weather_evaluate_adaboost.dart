/// WEATHER dataset MODEL BOOST ADAPTIVE  EVALUATE feature.
//
// Time-stamp: <Friday 2025-01-31 15:50:39 +1100 Graham Williams>
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
import 'package:rattle/features/boost/panel.dart';

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

  group('WEATHER MODEL BOOST ADAPTIVE  EVALUATE:', () {
    testWidgets('build, evaluate, verify.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');

      await navigateToFeature(tester, 'Boost', BoostPanel);
      await tapChip(tester, 'Adaptive');
      await tapButton(tester, 'Build Boosted Trees');
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await gotoNextPage(tester);
      await verifyPage('Error Matrix');

      await verifySelectableText(
        tester,
        [
          'No  42   1   2.3',
          'Yes 10   1  90.9',
          'No  77.8 1.9   2.3',
          'Yes 18.5 1.9  90.9',
          'Overall Error = 20.37%; Average Error = 46.62%.',
        ],
      );
    });
  });
}
