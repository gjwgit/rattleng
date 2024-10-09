/// Model NNET test with demo dataset.
//
// Time-stamp: <Wednesday 2024-10-09 17:28:28 +1100 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/neural/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/open_demo_dataset.dart';

/// List of specific variables that should have their role set to 'Ignore' in
/// demo dataset. These are factors/chars and don't play well with nnet.

final List<String> demoVariablesToIgnore = [
  'wind_gust_dir',
  'wind_dir_9am',
  'wind_dir_3pm',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NNET Model Demo Tree:', () {
    testWidgets('default test.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDemoDataset(tester);

      await tester.pump(interact);

      // Find the scrollable ListView.

      final scrollableFinder = find.byKey(const Key('roles listView'));

      // Iterate over each variable in the list and find its corresponding row in the ListView.

      for (final variable in demoVariablesToIgnore) {
        bool foundVariable = false;

        // Scroll in steps and search for the variable until it's found.

        while (!foundVariable) {
          // Find the row where the variable name is displayed.

          final variableFinder = find.text(variable);

          if (tester.any(variableFinder)) {
            foundVariable = true;

            // Find the parent widget that contains the variable and its associated ChoiceChip.

            final parentFinder = find.ancestor(
              of: variableFinder,
              matching: find.byType(
                Row,
              ),
            );

            // Select the first Row in the list.

            final firstRowFinder = parentFinder.first;

            // Tap the correct ChoiceChip to change the role to 'Ignore'.

            final ignoreChipFinder = find.descendant(
              of: firstRowFinder,
              matching: find.text('Ignore'),
            );

            await tester.tap(ignoreChipFinder);

            await tester.pumpAndSettle();

            // Verify that the role is now set to 'Ignore'.

            expect(ignoreChipFinder, findsOneWidget);
          } else {
            final currentScrollableFinder = scrollableFinder.first;

            // Fling (or swipe) down by a small amount.

            await tester.fling(
              currentScrollableFinder,
              const Offset(0, -300), // Scroll down
              1000,
            );
            await tester.pumpAndSettle();
            await tester.pump(delay);

            // Tab the previous variable to avoid missing tab it.
            // Missing tab happens if Ignore button overlaps the rightArrow icon.

            int index = demoVariablesToIgnore.indexOf(variable);
            if (index > 0) {
              String preVariable = demoVariablesToIgnore[index - 1];

              // Find the row where the variable name is displayed.

              final preVariableFinder = find.text(preVariable);

              if (tester.any(preVariableFinder)) {
                // Find the parent widget that contains the variable and its associated ChoiceChip.

                final preParentFinder = find.ancestor(
                  of: preVariableFinder,
                  matching: find.byType(
                    Row,
                  ),
                );

                // Select the first Row in the list.

                final firstRowFinder = preParentFinder.first;

                // Tap the correct ChoiceChip to change the role to 'Ignore'.

                final ignoreChipFinder = find.descendant(
                  of: firstRowFinder,
                  matching: find.text('Ignore'),
                );

                await tester.tap(ignoreChipFinder);

                await tester.pumpAndSettle();

                // Verify that the role is now set to 'Ignore'.

                expect(ignoreChipFinder, findsOneWidget);
              }
            }
          }
        }
      }

      // Find the Model Page in the Side tab.

      final modelTabFinder = find.byIcon(Icons.model_training);

      // Tap the model Tab button.

      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the Neural feature.

      await navigateToFeature(tester, 'Neural', NeuralPanel);

      await tester.pumpAndSettle();

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Simulate the presence of a neural network being built.

      final neuralNetworkButton = find.byKey(const Key('Build Neural Network'));

      await tester.tap(neuralNetworkButton);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      await tester.tap(neuralNetworkButton);
      await tester.pumpAndSettle();

      // Pause for a long time to wait for app gets stable.

      await tester.pump(hack);

      // await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await tester.pump(interact);
      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);

      // Check if SelectableText contains the expected content.

      final modelDescriptionFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.data?.contains('A 15-10-1 network with 171 weights') == true,
      );

      // Ensure the SelectableText widget with the expected content exists.

      expect(modelDescriptionFinder, findsOneWidget);

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      final optionsDescriptionFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.data?.contains(
                  'Options were - entropy fitting.',
                ) ==
                true,
      );

      // Ensure the SelectableText widget with the expected content exists.

      expect(optionsDescriptionFinder, findsOneWidget);

      await tester.pump(interact);

      // Tap the right arrow to go to the next page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await tester.pump(interact);

      final forthPageTitleFinder = find.text('Neural Net Model - Visual');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });

    testWidgets('nnet model with different parameter settings.',
        (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.pump(interact);

      await openDemoDataset(tester);

      await tester.pumpAndSettle();

      // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      await tester.pump(longHack);

      // Tap the right arrow button to go to Variable page.

      // await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(hack);
      await tester.pump(interact);

      // Find the scrollable ListView.

      final scrollableFinder = find.byKey(const Key('roles listView'));

      // Iterate over each variable in the list and find its corresponding row in the ListView.

      for (final variable in demoVariablesToIgnore) {
        bool foundVariable = false;

        // Scroll in steps and search for the variable until it's found.

        while (!foundVariable) {
          // Find the row where the variable name is displayed.

          final variableFinder = find.text(variable);

          if (tester.any(variableFinder)) {
            foundVariable = true;

            // Find the parent widget that contains the variable and its associated ChoiceChip.

            final parentFinder = find.ancestor(
              of: variableFinder,
              matching: find.byType(
                Row,
              ),
            );

            // Select the first Row in the list.

            final firstRowFinder = parentFinder.first;

            // Tap the correct ChoiceChip to change the role to 'Ignore'.

            final ignoreChipFinder = find.descendant(
              of: firstRowFinder,
              matching: find.text('Ignore'),
            );

            await tester.tap(ignoreChipFinder);

            await tester.pumpAndSettle();

            // Verify that the role is now set to 'Ignore'.

            expect(ignoreChipFinder, findsOneWidget);
          } else {
            final currentScrollableFinder = scrollableFinder.first;

            // Fling (or swipe) down by a small amount.

            await tester.fling(
              currentScrollableFinder,
              const Offset(0, -300), // Scroll down
              1000,
            );
            await tester.pumpAndSettle();
            await tester.pump(delay);

            // Tab the previous variable to avoid missing tab it.
            // Missing tab happens if Ignore button overlaps the rightArrow icon.

            int index = demoVariablesToIgnore.indexOf(variable);
            if (index > 0) {
              String preVariable = demoVariablesToIgnore[index - 1];

              // Find the row where the variable name is displayed.

              final preVariableFinder = find.text(preVariable);

              if (tester.any(preVariableFinder)) {
                // Find the parent widget that contains the variable and its associated ChoiceChip.

                final preParentFinder = find.ancestor(
                  of: preVariableFinder,
                  matching: find.byType(
                    Row,
                  ),
                );

                // Select the first Row in the list.

                final firstRowFinder = preParentFinder.first;

                // Tap the correct ChoiceChip to change the role to 'Ignore'.

                final ignoreChipFinder = find.descendant(
                  of: firstRowFinder,
                  matching: find.text('Ignore'),
                );

                await tester.tap(ignoreChipFinder);

                await tester.pumpAndSettle();

                // Verify that the role is now set to 'Ignore'.

                expect(ignoreChipFinder, findsOneWidget);
              }
            }
          }
        }
      }

      final modelTabFinder = find.byIcon(Icons.model_training);
      expect(modelTabFinder, findsOneWidget);

      // Tap the model Tab button.

      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the Neural feature.

      await navigateToFeature(tester, 'Neural', NeuralPanel);

      await tester.pumpAndSettle();

      // Find and tap the 'Trace' checkbox.

      final Finder traceCheckbox = find.byKey(const Key('NNET Trace'));
      await tester.tap(traceCheckbox);
      await tester.pumpAndSettle(); // Wait for UI to settle.

      // Find the text fields by their keys and enter the new values.

      await tester.enterText(find.byKey(const Key('hidden_neurons')), '11');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('max_NWts')), '10001');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('maxit')), '101');
      await tester.pumpAndSettle();

      // Simulate the presence of a decision tree being built.

      final neuralNetworkButton = find.byKey(const Key('Build Neural Network'));

      await tester.tap(neuralNetworkButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);
      await tester.pump(interact);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      // await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);
      await tester.pump(interact);

      // Check if SelectableText contains the expected content.

      final modelDescriptionFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.data?.contains('A 15-11-1 network with 188 weights') == true,
      );

      // Ensure the SelectableText widget with the expected content exists.

      // TODO 20241001 kev the underneath code is not working as expected

      expect(modelDescriptionFinder, findsOneWidget);

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      await tester.pump(interact);

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);
      await tester.pump(interact);

      final forthPageTitleFinder = find.text('Neural Net Model - Visual');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
