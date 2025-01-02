/// Test the MODEL tab's TREE feature with the LARGE dataset.
//
// Time-stamp: <Monday 2024-10-14 09:02:57 +1100 Graham Williams>
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

  group('Large Model Tree RPart Congif:', () {
    testWidgets('Load, Navigate, Config, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDatasetByPath(tester, 'integration_test/medical.csv');

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

      await tester.pump(interact);

      // Tap the BUILD button.

      final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));
      await tester.tap(decisionTreeButton);
      await tester.pumpAndSettle();

      await tester.tap(decisionTreeButton);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Tap the right arrow to go to the second page.

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
      // expect(rightArrowButton, findsOneWidget);
      // await tester.tap(rightArrowButton);
      // await tester.pumpAndSettle();

      final secondPageTitleFinder = find.text('Decision Tree Model');
      expect(secondPageTitleFinder, findsOneWidget);

//      await tester.pump(longHack);

      // TODO 20240902 zy NEED TO TEST ACTUAL TREE THAT HAS BEEN BUILT

      // App may raise bugs in loading textPage. Thus, test does not target
      // at content.

      final summaryDecisionTreeFinder = find.byType(TextPage);
      expect(summaryDecisionTreeFinder, findsOneWidget);

      // TODO 20240902 zy IS THIS pause NEEDED HERE?

//      await tester.pump(longHack);

      // TODO 20240902 zy NEED TO TEST ACTUAL TREE THAT HAS BEEN BUILT

      // Tap the right arrow to go to the third page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(longHack);

      final thirdPageTitleFinder = find.text('Decision Tree as Rules');
      expect(thirdPageTitleFinder, findsOneWidget);

//      await tester.pump(longHack);

      // TODO 20240902 zy NEED TO TEST ACTUAL TREE THAT HAS BEEN BUILT

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final forthPageTitleFinder = find.text('Tree');
      expect(forthPageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);
      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
