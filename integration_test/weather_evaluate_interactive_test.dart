/// Test the INTERACTIVE prediction popup of the EVALUATE tab.
///
/// Time-stamp: "Saturday 2026-08-15 10:12:00 +1000 Graham Williams"
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

import 'package:rattle/features/evaluate/interactive_field.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/wait_for_r.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER MODEL TREE RPART INTERACTIVE:', () {
    testWidgets('build, predict a single observation.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree');
      await tapButton(tester, 'Build Decision Tree');
      await navigateToTab(tester, 'Evaluate');

      // Building the tree ticks the Tree model, so INTERACTIVE is enabled.

      await tapButton(tester, 'Interactive');
      expect(find.text('Interactive Prediction'), findsOneWidget);

      // The popup asks R to describe the input variables, which takes a moment
      // to come back through the console.

      await waitForR(tester);

      // A field per input variable, each with its value from the dataset, so
      // that a prediction can be made without entering anything.

      expect(find.byType(InteractiveField), findsWidgets);

      await tapButton(tester, 'Predict');
      await waitForR(tester);

      // The model describes itself through `mdesc` in the reported prediction.

      expect(find.text('Decision Tree'), findsOneWidget);

      // The prediction is one of the levels of the target variable.

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              (widget.data == 'No' || widget.data == 'Yes') &&
              widget.style?.fontWeight == FontWeight.bold,
        ),
        findsOneWidget,
      );

      await tester.pump(interact);
      await tapButton(tester, 'Close');
    });
  });
}
