/// Test the MODEL tab's TREE feature with the LARGE dataset.
//
// Time-stamp: <Tuesday 2025-02-04 10:38:47 +1100 Graham Williams>
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

// TODO 20250124 gjw THIS NEEDS A LOT OF WORK TO GET IT USEFUL - DECLARATIVE

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Load, Navigate, Build, Page.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
    await navigateToTab(tester, 'Model');
    await navigateToFeature(tester, 'Tree', TreePanel);
    final markdownContent = find.byKey(const Key('markdown_file'));
    expect(markdownContent, findsOneWidget);
    await tapButton(tester, 'Build Decision Tree');
    // 20250203 gjw Had to add two delays on ecosysl to await the
    // model to be built.
    await tester.pump(delay);
    await tester.pump(delay);
    await gotoNextPage(tester);
    // 20250203 gjw Needed another delay on ecosysl after going to
    // the next page.
    await tester.pump(delay);
    await verifyPage('Decision Tree Model');
    await gotoNextPage(tester);

// 20250203 gjw Add the following back in.

//     await tester.pump(interact);

//     // Tap the right arrow to go to the third page.

//     await tester.tap(rightArrowButton);
//     await tester.pumpAndSettle();

// //    final thirdPageTitleFinder = find.text('Decision Tree as Rules');
// //    expect(thirdPageTitleFinder, findsOneWidget);

//     // App may raise bugs in loading textPage. Thus, test does not target
//     // at content.

// //    final decisionTreeRulesFinder = find.byType(TextPage);
// //    expect(decisionTreeRulesFinder, findsOneWidget);

//     await tester.pump(interact);

//     // Tap the right arrow to go to the forth page.

//     await tester.tap(rightArrowButton);
//     await tester.pumpAndSettle();

// //    final forthPageTitleFinder = find.text('Tree');
// //    expect(forthPageTitleFinder, findsOneWidget);

// //    final imageFinder = find.byType(ImagePage);

//     // Assert that the image is present.

// //    expect(imageFinder, findsOneWidget);

    await tester.pump(interact);
  });
}
