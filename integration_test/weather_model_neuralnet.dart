/// Test neuralnet() with demo dataset.
//
// Time-stamp: <Saturday 2024-10-12 19:06:03 +1100 Graham Williams>
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
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/unify_on.dart';

// List of specific variables that should have their role set to 'Ignore' in
// demo dataset. These are factors/chars and don't play well with nnet.

final List<String> demoVariablesToIgnore = [
  'wind_gust_dir',
  'wind_dir_9am',
  'wind_dir_3pm',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Model Neuralnet:', () {
    testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await unifyOn(tester);

      await loadDemoDataset(tester);

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

      await navigateToPage(
        tester,
        Icons.model_training,
        ModelTabs,
      );

      // Navigate to the Neural feature.

      await navigateToFeature(tester, 'Neural', NeuralPanel);

      await tester.pumpAndSettle();

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Find the ChoiceChipTip widget for the algorithm type.

      final neuralnetChip = find.text(
        'neuralnet',
      );

      // Tap the neuralnet chip to switch algorithm.

      await tester.tap(neuralnetChip);
      await tester.pumpAndSettle();

      await tapButton(tester, 'Build Neural Network');

      await tester.pump(longHack);

      await tapButton(tester, 'Build Neural Network');

      // Check if SelectableText contains the expected content.

      final modelDescriptionFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.data?.contains('data = ds_onehot,') == true,
      );

      // Ensure the SelectableText widget with the expected content exists.

      expect(modelDescriptionFinder, findsOneWidget);

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      await tester.pump(interact);

      // Tap the right arrow to go to the next page.

      await gotoNextPage(tester);

      await tester.pump(hack);

      await gotoNextPage(tester);

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
