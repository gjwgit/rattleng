/// Test nnet() with numeric demo dataset.
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
import 'package:rattle/tabs/model.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/open_weather_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Numeric Demo Model Neural NNet:', () {
    testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openWeatherDataset(tester);

      await tester.pump(interact);

      await navigateToPage(
        tester,
        Icons.model_training,
        ModelTabs,
      );
      await tester.pumpAndSettle();

      // Navigate to the Neural feature.

      await navigateToFeature(tester, 'Neural', NeuralPanel);

      await tester.pumpAndSettle();

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Find and tap the 'Ignore Categoric' checkbox.

      final Finder ignoreCheckbox =
          find.byKey(const Key('Neural Ignore Categoric'));
      await tester.tap(ignoreCheckbox);
      await tester.pumpAndSettle();

      // Simulate the presence of a neural network being built.

      final neuralNetworkButton = find.byKey(const Key('Build Neural Network'));

      await tester.tap(neuralNetworkButton);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      await tester.tap(neuralNetworkButton);
      await tester.pumpAndSettle();

      // Pause for a long time to wait for app gets stable.

      await tester.pump(hack);

      await tester.pump(interact);
      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);

      // Check if SelectableText contains the expected content.

      final modelDescriptionFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.data?.contains('A 14-10-1 network with 161 weights') == true,
      );

      // Ensure the SelectableText widget with the expected content exists.

      expect(modelDescriptionFinder, findsOneWidget);

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      final optionsDescriptionFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.data?.contains(
                  'Options were - entropy fitting',
                ) ==
                true,
      );

      // Ensure the SelectableText widget with the expected content exists.

      expect(optionsDescriptionFinder, findsOneWidget);

      await tester.pump(interact);

      // Tap the right arrow to go to the next page.

      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await tester.pump(interact);

      await gotoNextPage(tester);

      final forthPageTitleFinder = find.text('Neural Net Model - Visual');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
