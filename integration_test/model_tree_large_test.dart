/// Test the MODEL tab's TREE feature with the LARGE dataset.
//
// Time-stamp: <Monday 2024-09-02 10:50:25 +1000 Graham Williams>
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

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/number_field.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_large_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Model Large Tree:', () {
    testWidgets('raprt.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // TODO 20240902 zy USE utils/open_large_file_dataset.dart
      //
      // The following will be in openLargeFileDataset(). Model it on
      // openDemoSateset().

      await openLargeDataset(tester);

      // 20240822 TODO gjw DOES THIS NEED A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      await tester.pump(hack);

      // Tap the model Tab button.

      await navigateToTab(tester, 'Model');

      // Navigate to the Tree feature.

      await navigateToFeature(tester, 'Tree', TreePanel);

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Simulate the presence of a decision tree being built

      final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));

      await tester.tap(decisionTreeButton);

      await tester.pumpAndSettle();

      // Pause for a long time to wait for app to get stable.

      await tester.pump(hack);

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

      final decisionTreeRulesFinder = find.byType(TextPage);
      expect(decisionTreeRulesFinder, findsOneWidget);

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

    testWidgets('Traditional Parameters.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // TODO 20240902 zy USE utils/open_large_file_dataset.dart
      //
      // The following will be in openLargeFileDataset(). Model it on
      // openDemoSateset().

      await openLargeDataset(tester);

      // Tap the model Tab button.

      await navigateToTab(tester, 'Model');

      // Navigate to the Tree feature.

      await navigateToFeature(tester, 'Tree', TreePanel);

      // Find and tap the 'Include Missing' checkbox.

      final Finder includeMissingCheckbox = find.byType(Checkbox);
      await tester.tap(includeMissingCheckbox);
      await tester.pumpAndSettle();

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

      await tester.pump(longHack);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowButton, findsOneWidget);
      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

      await tester.pump(longHack);

      // TODO 20240902 zy NEED TO TEST ACTUAL TREE THAT HAS BEEN BUILT

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      // TODO 20240902 zy IS THIS pause NEEDED HERE?

      await tester.pump(longHack);

      // TODO 20240902 zy NEED TO TEST ACTUAL TREE THAT HAS BEEN BUILT

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(longHack);

      final thirdPageTitleFinder = find.text('Decision Tree as Rules');
      expect(thirdPageTitleFinder, findsOneWidget);

      await tester.pump(longHack);

      // TODO 20240902 zy NEED TO TEST ACTUAL TREE THAT HAS BEEN BUILT

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final forthPageTitleFinder = find.text('Tree');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);
      expect(imageFinder, findsOneWidget);

      await tester.pump(pause);
    });

    /// TODO 20240826 zy CONDITIONAL TREE NOT OPERATIOANL.
    ///
    /// Only testing UI functions.

    testWidgets('Conditional.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // TODO 20240902 zy USE utils/open_large_file_dataset.dart
      //
      // The following will be in openLargeFileDataset(). Model it on
      // openDemoSateset().

      await openLargeDataset(tester);

      // Tap the model Tab button.

      await navigateToTab(tester, 'Model');

      // Navigate to the Tree feature.

      await navigateToFeature(tester, 'Tree', TreePanel);

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
      await tester.pump(longHack);

      // Optionally, verify any side effects (e.g., UI changes due to the
      // selected algorithm).  Example: Check for a label update

      final modelBuilderLabel = find.text('Model Builder: ctree');
      expect(modelBuilderLabel, findsOneWidget);

      // Now switch back to the traditional algorithm.

      await tester.tap(traditionalChip);

      // Wait for the widget to rebuild and settle.

      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Optionally, verify UI updates for the traditional algorithm.

      final modelBuilderRpartLabel = find.text('Model Builder: rpart');
      expect(modelBuilderRpartLabel, findsOneWidget);

      // Tap the conditional chip to switch algorithms.

      await tester.tap(conditionalChip);

      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Verify the relevant fields are disabled when Conditional is selected.

      final complexityField = find.byKey(const Key('complexityField'));
      final priorsField = find.byKey(const Key('priorsField'));
      final lossMatrixField = find.byKey(const Key('lossMatrixField'));

      // Ensure that these fields are disabled (meaning that they are not accepting input).

      expect(tester.widget<NumberField>(complexityField).enabled, isFalse);
      expect(tester.widget<TextFormField>(priorsField).enabled, isFalse);
      expect(tester.widget<TextFormField>(lossMatrixField).enabled, isFalse);

      // Now switch back to the traditional algorithm.

      await tester.tap(traditionalChip);
      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Verify that the relevant fields are now enabled.

      expect(tester.widget<NumberField>(complexityField).enabled, isTrue);
      expect(tester.widget<TextFormField>(priorsField).enabled, isTrue);
      expect(tester.widget<TextFormField>(lossMatrixField).enabled, isTrue);

      await tester.pumpAndSettle();
      await tester.pump(pause);
    });
  });
}
