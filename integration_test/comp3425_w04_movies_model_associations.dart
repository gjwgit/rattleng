/// COMP3425 W04 MOVIES dataset MODEL tab ASSOCIATION feature.
//
// Time-stamp: <Tuesday 2025-05-06 14:00:51 +1000 >
//
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/enter_text.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_partition.dart';
import 'utils/tap_button.dart';
import 'utils/verify_checkbox.dart';
import 'utils/verify_dataset_role.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W04 LAB MOVIES ASSOCIATION:', () {
    testWidgets('model, impute occupation, model.', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await setPartition(tester, false);
      await loadDemoDataset(tester, 'Movies');
      await verifyDatasetRole('basket', 'Ident');
      await verifyDatasetRole('item', 'Target');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Associations');
      await verifyCheckbox(tester, 'Baskets', true);
      await tapButton(tester, 'Build Association Rules');
      await navigateToPage(
        tester,
        1,
        title: 'Association Rules — Meta Summary',
      );
      await verifySelectableText(tester, [
        'set of 44 rules',
        '   support         confidence       coverage          lift           count',
        'Min.   :0.1000   Min.   :0.200   Min.   :0.100   Min.   :0.500   Min.   :1.000',
        '1st Qu.:0.1000   1st Qu.:0.500   1st Qu.:0.100   1st Qu.:1.250   1st Qu.:1.000',
        'Median :0.1000   Median :0.550   Median :0.200   Median :2.500   Median :1.000',
        'Mean   :0.1227   Mean   :0.675   Mean   :0.225   Mean   :2.661   Mean   :1.227',
        '3rd Qu.:0.1000   3rd Qu.:1.000   3rd Qu.:0.300   3rd Qu.:5.000   3rd Qu.:1.000',
        'Max.   :0.3000   Max.   :1.000   Max.   :0.500   Max.   :5.000   Max.   :3.000 ',
        'list(support = 0.1, confidence = 0.1, minlen = 2)',
      ]);
      await gotoNextPage(tester, title: 'Association Rules — Discovered Rules');
      await verifySelectableText(tester, [
        '[1]  {Patriot}                                => {Gladiator}',
        '0.3     0.6000000  0.5      1.2000000 3',
        '[9]  {Harry Potter1}                          => {LOTR2}',
        '0.1     0.5000000  0.2      2.5000000 1',
        '[44] {Green Mile, LOTR2, Sixth Sense}         => {Harry Potter1}',
      ]);
      await verifySelectableText(tester, ['[45]'], present: false);
      await enterText(tester, 'association_config_limit_rules', '5000');
      await tapButton(tester, 'Build Association Rules');
      await navigateToPage(
        tester,
        2,
        title: 'Association Rules — Discovered Rules',
      );
      await verifySelectableText(tester, ['[30]'], present: true);
      await verifySelectableText(tester, ['[31]'], present: true);
      await gotoNextPage(tester, title: 'Association Rules — Item Frequency');
      await gotoNextPage(
        tester,
        title: 'Association Rules — Graph of Associations',
      );
      await gotoNextPage(
        tester,
        title: 'Association Rules — Parrallel Coordinates Plot',
      );
    });
    // testWidgets('support = 0.01.', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();
    //   await setPartition(tester, false);
    //   await loadDemoDataset(tester, 'Movies');
    //   await verifyDatasetRole('basket', 'Ident');
    //   await verifyDatasetRole('item', 'Target');
    //   await navigateToTab(tester, 'Model');
    //   await navigateToFeature(tester, 'Associations');
    //   await verifyCheckbox(tester, 'Baskets', true);
    //   await enterText(tester, 'association_config_support', '0.01');
    //   await tester.pump(delay);
    //   await tapButton(tester, 'Build Association Rules');
    //   await navigateToPage(tester, 1, title: 'Association Rules — Meta Summary');
    //   await verifySelectableText(tester, ['support = 0.01']);
    //   await verifySelectableText(tester, ['117']);
    // });
    testWidgets('support = 0.001.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Movies');
      await verifyDatasetRole('basket', 'Ident');
      await verifyDatasetRole('item', 'Target');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Associations');
      await verifyCheckbox(tester, 'Baskets', true);
      await enterText(tester, 'association_config_support', '0.001');
      await tapButton(tester, 'Build Association Rules');
      await navigateToPage(
        tester,
        1,
        title: 'Association Rules — Meta Summary',
      );
      await verifySelectableText(tester, ['support = 0.001']);
      await verifySelectableText(tester, ['44']);
      await addDelay(tester, 10);
    });
  });
}
