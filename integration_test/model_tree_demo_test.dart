/// Model tree test with demo dataset.
//
// Time-stamp: <Tuesday 2024-09-03 09:09:14 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Model Demo Tree:', () {
    testWidgets('rpart.', (WidgetTester tester) async {
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

      // Pause for a long time to wait for app gets stable.

      await tester.pump(hack);

      // Optionally, you can test interactions with the TabPageSelector.

      final pageIndicator = find.byType(TabPageSelector);
      expect(pageIndicator, findsOneWidget);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final thirdPageTitleFinder = find.text('Decision Tree as Rules');
      expect(thirdPageTitleFinder, findsOneWidget);

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final ruleNumberFinder = find.byType(TextPage);
      expect(ruleNumberFinder, findsOneWidget);

      await tester.pump(pause);

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final forthPageTitleFinder = find.text('Tree');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await tester.pump(pause);
    });

    testWidgets('rpart with different parameter settings.',
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

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

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

    testWidgets('ctree.', (WidgetTester tester) async {
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

      await tester.pump(hack);

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

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await tester.pump(pause);
    });
  });
}
