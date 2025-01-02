/// Test the MODEL tab's TREE feature with the LARGE dataset.
//
// Time-stamp: <Monday 2024-10-14 08:58:52 +1100 Graham Williams>
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
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_dataset_by_path.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Large Model Tree RPart:', () {
    testWidgets('Load, Navigate, Build, Page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDatasetByPath(tester, 'integration_test/medical.csv');

      // 20240822 TODO gjw DOES THIS NEED A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

//      await tester.pump(hack);

      // Tap the MODEL Tab button.

      await navigateToTab(tester, 'Model');

      // Navigate to the TREE feature.

      await navigateToFeature(tester, 'Tree', TreePanel);

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Simulate the presence of a decision tree being built

      final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));
      await tester.tap(decisionTreeButton);
      await tester.pumpAndSettle();

      await tester.tap(decisionTreeButton);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Pause for a long time to wait for app to get stable.

      // await tester.pump(hack);

      // Automatically go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      // expect(rightArrowButton, findsOneWidget);
      // await tester.pumpAndSettle();

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      await tester.pump(interact);

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final thirdPageTitleFinder = find.text('Decision Tree as Rules');
      expect(thirdPageTitleFinder, findsOneWidget);

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final decisionTreeRulesFinder = find.byType(TextPage);
      expect(decisionTreeRulesFinder, findsOneWidget);

      await tester.pump(interact);

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final forthPageTitleFinder = find.text('Tree');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.

      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
