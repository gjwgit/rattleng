/// COMP3425 W5 WEATHER dataset MODEL tab TREE feature RPART option EVALUATE tab.
//
// Time-stamp: <Thursday 2025-02-13 07:03:04 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_text_field.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER MODEL TREE RPART EVALUATE:', () {
    testWidgets('build, evaluate, verify.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree', TreePanel);
      await tapButton(tester, 'Build Decision Tree');
      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await navigateToPage(tester, 1, 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'No  41   2   4.7',
          'Yes  7   4  63.6',
          'No  75.9 3.7   4.7',
          'Yes 13.0 7.4  63.6',
          'Overall Error = 16.67%; Average Error = 34.14%.',
        ],
      );
    });
    testWidgets('comp3425 w5 lab evaluation.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree', TreePanel);
      await tester.pumpAndSettle();
      await setTextField(tester, 'minSplitField', '1');
      await setTextField(tester, 'maxDepthField', '50');
      await setTextField(tester, 'minBucketField', '1');
      await setTextField(tester, 'complexityField', '0.01');
      await tapButton(tester, 'Build Decision Tree');
      await navigateToTab(tester, 'Evaluate');
      await tapChip(tester, 'Training');
      await tapButton(tester, 'Evaluate');
      await tester.pump(delay);
      await navigateToPage(tester, 1, 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'No  215   0   0.0',
          'Yes   1  38   2.6',
          'No  84.6   0   0.0',
          'Yes  0.4  15   2.6',
          'Overall Error = 0.39%; Average Error = 1.28%.',
        ],
      );
      await tapChip(tester, 'Validation');
      await tapButton(tester, 'Evaluate');
      await tester.pump(delay);
      await navigateToPage(tester, 1, 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'No  41   2   4.7',
          'Yes  7   4  63.6',
          'No  75.9 3.7   4.7',
          'Yes 13.0 7.4  63.6',
          'Overall Error = 16.67%; Average Error = 34.14%.',
        ],
      );
    });
  });
}
