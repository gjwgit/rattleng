/// Model tree test with demo dataset.
//
// Time-stamp: <Monday 2024-08-26 08:48:08 +0800 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/main.dart' as app;

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 5);
const Duration hack = Duration(seconds: 10);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Decision Trees for Demo Dataset:', () {
    testWidgets('Demo Dataset. Default Traditional.',
        (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final demoButton = find.text('Demo');
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      await tester.pump(hack);

      // Find the Model Page in the Side tab.

      final modelTabFinder = find.byIcon(Icons.model_training);

      // Tap the model Tab button.

      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the Tree feature.

      final treeTabFinder = find.text('Tree');
      await tester.tap(treeTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Simulate the presence of a decision tree being built.

      final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));

      await tester.tap(decisionTreeButton);

      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Optionally, you can test interactions with the TabPageSelector.

      final pageIndicator = find.byType(TabPageSelector);
      expect(pageIndicator, findsOneWidget);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final thirdPageTitleFinder = find.text('Decision Tree as Rules');
      expect(thirdPageTitleFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final forthPageTitleFinder = find.text('Tree');
      expect(forthPageTitleFinder, findsOneWidget);

      await tester.pump(pause);
    });

    testWidgets('Demo Dataset. Update Different Variables Traditional.',
        (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final demoButton = find.text('Demo');
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      await tester.pump(hack);

      final modelTabFinder = find.byIcon(Icons.model_training);
      expect(modelTabFinder, findsOneWidget);

      // Tap the model Tab button.

      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the Tree feature.

      final treeTabFinder = find.text('Tree');
      await tester.tap(treeTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find and tap the 'Include Missing' checkbox.
      final Finder includeMissingCheckbox = find.byType(Checkbox);
      await tester.tap(includeMissingCheckbox);
      await tester.pumpAndSettle(); // Wait for UI to settle.

      // Find the text fields by their keys and enter the new values.
      await tester.enterText(find.byKey(const Key('minSplitField')), '21');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('maxDepthField')), '29');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('minBucketField')), '9');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('complexityField')),
        '0.0110',
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('priorsField')), '0.5,0.5');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('lossMatrixField')),
        '0,10,1,0',
      );
      await tester.pumpAndSettle();

      // Simulate the presence of a decision tree being built.

      final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));

      await tester.tap(decisionTreeButton);

      await tester.pumpAndSettle();

      await tester.pump(delay);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final thirdPageTitleFinder = find.text('Decision Tree as Rules');
      expect(thirdPageTitleFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final forthPageTitleFinder = find.text('Tree');
      expect(forthPageTitleFinder, findsOneWidget);

      await tester.pump(pause);
    });

    testWidgets('Demo Dataset. Conditional.', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final demoButton = find.text('Demo');
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      await tester.pump(hack);

      // Find the Model Page in the Side tab.

      final modelTabFinder = find.byIcon(Icons.model_training);

      // Tap the model Tab button.

      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the Tree feature.

      final treeTabFinder = find.text('Tree');
      await tester.tap(treeTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the ChoiceChipTip widget for the traditional algorithm type.

      final traditionalChip = find.text(
        'Traditional',
      );
      final conditionalChip = find.text('Conditional');

      // Verify that both chips exist in the widget tree.

      expect(traditionalChip, findsOneWidget);
      expect(conditionalChip, findsOneWidget);

      // Tap the conditional chip to switch algorithms.

      await tester.tap(conditionalChip);

      await tester.pumpAndSettle();

      // Optionally, verify any side effects (e.g., UI changes due to the
      // selected algorithm).  Example: Check for a label update.

      final modelBuilderLabel = find.text('Model Builder: ctree');
      expect(modelBuilderLabel, findsOneWidget);

      // Now switch back to the traditional algorithm.

      await tester.tap(traditionalChip);

      // Wait for the widget to rebuild and settle.

      await tester.pumpAndSettle();

      // Optionally, verify UI updates for the traditional algorithm.

      final modelBuilderRpartLabel = find.text('Model Builder: rpart');
      expect(modelBuilderRpartLabel, findsOneWidget);

      // Tap the conditional chip to switch algorithms.

      await tester.tap(conditionalChip);

      await tester.pumpAndSettle();
      await tester.pump(pause);

      // Simulate the presence of a decision tree being built.

      final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));

      await tester.tap(decisionTreeButton);

      await tester.pumpAndSettle();

      await tester.pump(delay);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final thirdPageTitleFinder = find.text('Tree');
      expect(thirdPageTitleFinder, findsOneWidget);

      await tester.pump(pause);
    });
  });
}
