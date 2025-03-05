/// WEATHER dataset MODEL tab LINEAR feature.
//
// Time-stamp: <Thursday 2025-03-06 10:24:05 +1100 Graham Williams>
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

import 'package:rattle/features/linear/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

/// Specific variables with ROLE set to 'Ignore'.

final List<String> varsToIgnore = [
  'wind_gust_dir',
  'wind_dir_9am',
  'wind_dir_3pm',
  'rain_today',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER IGNORE MODEL LINEAR:', () {
    testWidgets('load, ignore, build, test.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Linear', LinearPanel);
      await tapButton(tester, 'Build Linear Model');
      await tester.pump(delay);
      await navigateToPage(tester, 1, 'Linear Model');
      await verifySelectableText(
        tester,
        [
          'glm(formula = form, family = binomial(link = "logit"), data = trds)',
          '(Intercept)     249.56414   85.79545   2.909  0.00363 **',
        ],
      );
      await tester.pump(interact);
      await gotoNextPage(tester, title: 'Linear Model - Visual');
      await verifyImage(tester);
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await navigateToPage(tester, 1, 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'No   3  12  80.0',
          'Yes  4   5  44.4',
          'No  12.5 50.0  80.0',
          'Yes 16.7 20.8  44.4',
          'Overall Error = 66.67%; Average Error = 62.22%.',
        ],
      );
      // 20250306 gjw The titles on these pages is different widget?
      //
      //await gotoNextPage(tester, title: '(ROC)');
      //await gotoNextPage(tester, title: 'H-Measure');
      //await gotoNextPage(tester, title: 'Risk Chart');
    });
  });
}
