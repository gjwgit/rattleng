/// COMP3425 W04 MOVIES dataset MODEL tab ASSOCIATION feature.
//
// Time-stamp: <Friday 2025-03-07 11:37:54 +1100 Graham Williams>
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
import 'package:rattle/main.dart' as app;

import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_partition.dart';
import 'utils/tap_button.dart';
import 'utils/verify_checkbox.dart';
import 'utils/verify_role.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W04 LAB MOVIES ASSOCIATION:', () {
    testWidgets('model, impute occupation, model.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await setPartition(tester, false);
      await loadDemoDataset(tester, 'Movies');
      await verifyRole('basket', 'Ident');
      await verifyRole('item', 'Target');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Associations', AssociationPanel);
      await verifyCheckbox(tester, 'Baskets', true);
      await tapButton(tester, 'Build Association Rules');
      await navigateToPage(tester, 1, 'Association Rules — Meta Summary');
      await verifySelectableText(
        tester,
        [
          'set of 117 rules',
          '   support         confidence        coverage           lift',
          'Min.   :0.1000   Min.   :0.1429   Min.   :0.1000   Min.   : 0.7143   Min.   :1.000',
          '1st Qu.:0.1000   1st Qu.:0.5000   1st Qu.:0.1000   1st Qu.: 1.6667   1st Qu.:1.000',
          'Median :0.1000   Median :1.0000   Median :0.1000   Median : 2.5000   Median :1.000',
          'Mean   :0.1316   Mean   :0.7980   Mean   :0.2128   Mean   : 3.1872   Mean   :1.316',
          '3rd Qu.:0.1000   3rd Qu.:1.0000   3rd Qu.:0.2000   3rd Qu.: 5.0000   3rd Qu.:1.000',
          'Max.   :0.6000   Max.   :1.0000   Max.   :0.7000   Max.   :10.0000   Max.   :6.000 ',
          'list(support = 0.1, confidence = 0.1, minlen = 2)',
        ],
      );
      await gotoNextPage(tester, title: 'Association Rules — Discovered Rules');
      await verifySelectableText(
        tester,
        [
          '[1]   {Patriot}                            => {Gladiator}',
          '0.6     1.0000000  0.6       1.4285714 6',
          '[9]   {Gladiator, Sixth Sense}             => {Patriot}',
          '0.4     0.8000000  0.5       1.3333333 4',
          '[100] {LOTR1, LOTR2, Sixth Sense}          => {Harry Potter1}',
        ],
      );
      await gotoNextPage(tester, title: 'Association Rules — Item Frequency');
      await gotoNextPage(
        tester,
        title: 'Association Rules — Graph of Associations',
      );
      await gotoNextPage(
        tester,
        title: 'Association Rules — Parrallel Coordinates Plot',
      );
      //   // 20250206 gjw If we turn partition off then we get different numbers.
      //   // await verifySelectableText(
      //   //   tester,
      //   //   [
      //   //     '19 rules',
      //   //     'Min.   :0.1035   Min.   :0.1557   Min.   :0.1125   Min.   :0.8435',
      //   //     'Median :0.1505   Median :0.5793   Median :0.3345   Median :1.0166',
      //   //     'transactions          2000     0.1        0.1',
      //   //     'support = 0.1, confidence = 0.1, minlen = 2',
      //   //   ],
      //   // );
      //   await navigateToPage(tester, 2, 'Association Rules - Discovered Rules');
      //   await verifySelectableText(
      //     tester,
      //     [
      //       'marital=Married',
      //       '=> {gender=Male}',
      //       'support   confidence coverage  lift      count',
      //       '0.4014286 0.8906498  0.4507143 1.3279123 562',
      //     ],
      //   );

      //   // Now IMPUTE missing for the Occupation and build again.

      //   await navigateToTab(tester, 'Dataset');
      //   await setDatasetRole(tester, 'occupation', 'Input');
      //   await navigateToTab(tester, 'Transform');
      //   await navigateToFeature(tester, 'Impute', ImputePanel);
      //   await setSelectedVariable(tester, 'occupation');
      //   await tapChip(tester, 'Constant');
      //   await tapButton(tester, 'Impute Missing Values');
      //   await navigateToPage(tester, 1, 'Dataset Summary');
      //   await verifySelectableText(
      //     tester,
      //     [
      //       'IMP_occupation',
      //     ],
      //   );

      //   // 20250205 gjw Rebuild the model and determin the difference?

      //   await navigateToTab(tester, 'Model');
      //   await navigateToFeature(tester, 'Associations', AssociationPanel);
      //   await tapButton(tester, 'Build Association Rules');
      //   await tester.pump(delay);
      //   await navigateToPage(tester, 1, 'Association Rules - Meta Summary');
      //   await verifySelectableText(
      //     tester,
      //     [
      //       'set of 23 rules',
      //     ],
      //   );
      //   await navigateToPage(tester, 2, 'Association Rules - Discovered Rules');
      //   await verifySelectableText(
      //     tester,
      //     [
      //       'marital=Married',
      //       '=> {gender=Male}',
      //       'support   confidence coverage  lift      count',
      //       '0.4014286 0.8906498  0.4507143 1.3279123 562',
      //     ],
      //   );
    });
  });
}
