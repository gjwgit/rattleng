/// Test nnet() with demo dataset.
//
// Time-stamp: <Sunday 2024-10-20 17:29:05 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/neural/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/ignore_variables.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/load_demo_dataset.dart';

// List of specific variables that should have their role set to 'Ignore' in
// demo dataset. These are factors/chars and don't play well with nnet.

final List<String> demoVariablesToIgnore = [
  'wind_gust_dir',
  'wind_dir_9am',
  'wind_dir_3pm',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Demo Model Neural NNet Config:', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDemoDataset(tester);

    await ignoreVariables(tester, demoVariablesToIgnore);

    final modelTabFinder = find.byIcon(Icons.model_training);
    expect(modelTabFinder, findsOneWidget);

    // Tap the MODEL tab button.

    await tester.tap(modelTabFinder);
    await tester.pumpAndSettle();

    // Navigate to the NEURAL feature.

    await navigateToFeature(tester, 'Neural', NeuralPanel);
    await tester.pumpAndSettle();

    // Find and tap the 'Trace' checkbox.

    final Finder traceCheckbox = find.byKey(const Key('NNET Trace'));
    await tester.tap(traceCheckbox);
    await tester.pumpAndSettle();

    // Find the text fields by their keys and enter new values.

    await tester.enterText(find.byKey(const Key('hidden_layers')), '5');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('max_nwts')), '100');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('maxit')), '20');
    await tester.pumpAndSettle();

    // Tap the BUILD button.

    final neuralNetworkButton = find.byKey(const Key('Build Neural Network'));
    await tester.tap(neuralNetworkButton);
    await tester.pumpAndSettle();

    // 20241020 gjw Tap the BUILD button again while we wait for the bug of
    // not goinh to the next page is fixed.

    await tester.tap(neuralNetworkButton);
    await tester.pumpAndSettle();

    await tester.pump(interact);

    // Check the right arrow exists.

    final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
    expect(rightArrowButton, findsOneWidget);
    await tester.pumpAndSettle();

    // Ensure the DISPLAY has expected content.

    final modelDescriptionFinder = find.byWidgetPredicate(
      (widget) =>
          widget is SelectableText &&
          widget.data?.contains('A 15-5-1 network with 86 weights') == true,
    );
    expect(modelDescriptionFinder, findsOneWidget);

    final summaryDecisionTreeFinder = find.byType(TextPage);
    expect(summaryDecisionTreeFinder, findsOneWidget);

    await tester.pump(interact);

    // Tap the right arrow to go to the VISUAL page.

    await tester.tap(rightArrowButton);
    await tester.pumpAndSettle();

    final pageTitleFinder = find.text('Neural Net Model - Visual');
    expect(pageTitleFinder, findsOneWidget);

    final imageFinder = find.byType(ImagePage);
    expect(imageFinder, findsOneWidget);

    await tester.pump(interact);
  });
}
