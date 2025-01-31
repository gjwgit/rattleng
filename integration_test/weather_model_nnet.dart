/// Test nnet() with demo dataset.
//
// Time-stamp: <Friday 2025-01-31 13:54:42 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/neural/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

// List of specific variables that should have their role set to 'Ignore' in
// demo dataset. These are factors/chars and don't play well with nnet.

final List<String> varsToIgnore = [
  'wind_gust_dir',
  'wind_dir_9am',
  'wind_dir_3pm',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Model Neural NNet:', () {
    testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester);
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Neural', NeuralPanel);
      await tapButton(tester, 'Build Neural Network');
      await tester.pump(delay);
      await gotoNextPage(tester);
      await tester.pump(delay);
      await verifyPage('Neural Net Model - Summary and Weights');
      await verifySelectableText(
        tester,
        [
          'A 14-10-1 network with 171 weights',
          'Options were - skip-layer connections  entropy fitting',
        ],
      );
      await gotoNextPage(tester);
      await verifyPage('Neural Net Model - Visual');

      final imageFinder = find.byType(ImagePage);
      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
