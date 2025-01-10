/// Test AUDIT dataset TREE model RPART.
//
// Time-stamp: <Friday 2025-01-10 12:03:35 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

//import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
//import 'package:rattle/widgets/image_page.dart';
//import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Audit Dataset Tree Model Rpart.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDemoDataset(tester, 'Audit');

    await navigateToTab(tester, 'Model');
    await navigateToFeature(tester, 'Tree', TreePanel);
    await tapButton(tester, 'Build Decision Tree');

    await tester.pump(hack);

    await gotoNextPage(tester);
    await verifyPage('Decision Tree Model', 'Observations = 1400');

    await verifyText(
      tester,
      [
        // 20250110 gjw We get a trivial decision tree initially since
        // adjustment is actually an output variable.

        '1) root 1400 319 0 (0.77214286 0.22785714)',
        '2) adjustment< 123.5 1126  45 0 (0.96003552 0.03996448) *',
        '3) adjustment>=123.5 274   0 1 (0.00000000 1.00000000) *',

        // 20250110 gjw Do we always get the same values for the CP table?

        '2 0.01000      1   0.14107 0.14107 0.020688',
      ],
    );

    // TODO 20250110 gjw SET adjustment AS THE risk VARIABLE.

    // setDatasetRole('Risk')

    // // Tap the right arrow to go to the second page.

    // final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
    // expect(rightArrowButton, findsOneWidget);
    // // await tester.tap(rightArrowButton);
    // //await tester.pumpAndSettle();

    // // Try tapping again as it may not have gone to the second page.

    // await tester.tap(decisionTreeButton);

    // await tester.pump(hack);

    // final secondPageTitleFinder = find.text('Decision Tree Model');
    // expect(secondPageTitleFinder, findsOneWidget);

    // // App may raise bugs in loading textPage. Thus, test does not target
    // // at content.

    // final summaryDecisionTreeFinder = find.byType(TextPage);
    // expect(summaryDecisionTreeFinder, findsOneWidget);

    // await tester.pump(interact);

    // // Tap the right arrow to go to the third page.

    // await tester.tap(rightArrowButton);
    // await tester.pumpAndSettle();

    // final thirdPageTitleFinder = find.text('Decision Tree as Rules');
    // expect(thirdPageTitleFinder, findsOneWidget);

    // // App may raise bugs in loading textPage. Thus, test does not target
    // // at content.

    // final ruleNumberFinder = find.byType(TextPage);
    // expect(ruleNumberFinder, findsOneWidget);

    // await tester.pump(interact);

    // // Tap the right arrow to go to the forth page.

    // await tester.tap(rightArrowButton);
    // await tester.pumpAndSettle();

    // final forthPageTitleFinder = find.text('Tree');
    // expect(forthPageTitleFinder, findsOneWidget);

    // final imageFinder = find.byType(ImagePage);

    // // Assert that the image is present.
    // expect(imageFinder, findsOneWidget);

    // await tester.pump(interact);
  });
}
