/// Test AUDIT dataset MODEL tab ASSOCIATION feature.
//
// Time-stamp: <Tuesday 2025-02-04 15:57:01 +1100 Graham Williams>
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/association/panel.dart';
import 'package:rattle/features/impute/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AUDIT MODEL ASSOCIATION:', () {
    testWidgets('model, impute occupation, model.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Audit');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Associations', AssociationPanel);
      await tapButton(tester, 'Build Association Rules');
      await tester.pump(delay);
      await gotoNextPage(tester);
      await verifyPage('Association Rules - Meta Summary');
      await verifySelectableText(
        tester,
        [
          '52 rules',
        ],
      );
      await gotoNextPage(tester);
      await verifyPage('Association Rules - Discovered Rules');
      await verifySelectableText(
        tester,
        [
          'gender=Male',
          'employment=Private',
          '0.4585714 0.6837061  0.6707143 0.9777206 642',
        ],
      );

      // Now IMPUTE missing for the Occupation and build again.

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Impute', ImputePanel);
      // TODO 20250204 gjw CONTINUE HERE WHEN HAVE setSelectedVar('occupation')
      //
      // Want to impute CONSTANT for missing occupation and then test what has
      // changed in the rules.
      //
      await tapButton(tester, 'Impute Missing Values');

      // TODO 20241228 gjw THIS IS FAILING TO BE RENDERED IN FLUTTER
      //
      // It might require a bug report to the svg package.

      // await gotoNextPage(tester);
      // var imageFinder = find.byType(ImagePage);
      // expect(imageFinder, findsOneWidget);

      // await gotoNextPage(tester);
      // await verifyPage('Parrallel Coordinates Plot');
      // imageFinder = find.byType(ImagePage);
      // expect(imageFinder, findsOneWidget);

      // await gotoNextPage(tester);
      // await verifyPage('Item Frequency');
      // imageFinder = find.byType(ImagePage);
      // expect(imageFinder, findsOneWidget);
    });
  });
}
