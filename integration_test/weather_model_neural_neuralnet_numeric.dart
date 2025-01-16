/// Test neuralnet() with numeric demo dataset.
//
// Time-stamp: <Sunday 2024-10-13 15:00:27 +1100 Graham Williams>
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

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/tap_chip.dart';
import 'utils/tap_checkbox.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Numeric Demo Model Neural NNet:', () {
    testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDemoDataset(tester);

      await tester.pump(interact);

      await navigateToTab(tester, 'Model');

      await navigateToFeature(tester, 'Neural', NeuralPanel);

      await verifyMarkdown(tester);

      await tapChip(tester, 'neuralnet');
      await tapCheckbox(tester, 'Neural Ignore Categoric');

      // Simulate the presence of a neural network being built.
      await tapButton(tester, 'Build Neural Network');

      // Pause for a long time to wait for app gets stable.

      await tester.pump(hack);

      await tester.pump(interact);
      // Tap the right arrow to go to the second page.
      await gotoNextPage(tester);

      await verifySelectableText(
        'Neuralnet(formula = formula_nn, data = ds_final, hidden =',
      );

      await tester.pump(interact);

      await tester.pump(hack);

      await gotoNextPage(tester);

      await verifyPage('Neural Net Model - Visual');

      await verifyImage(tester);

      await tester.pump(interact);
    });
  });
}
