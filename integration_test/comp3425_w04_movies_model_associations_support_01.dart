/// COMP3425 W04 MOVIES dataset MODEL tab ASSOCIATION feature.
//
// Time-stamp: <Tuesday 2025-03-11 11:09:10 +1100 >
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

import 'utils/delays.dart';
import 'utils/enter_text.dart';
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

// Split into separate files instead of groups since the test is failing on
// ecosysl for some reason. Works just fine on kadesh. When split into separate
// files rather than group, it sometimes works on ecosysl but not
// always. Decoide to split into three separate files rather than three in a
// group (gjw 20250311).
//
// The error:
//
// The following StateError was thrown running a test (but after the test had completed):
// Bad state: Tried to read a provider from a ProviderContainer that was already disposed

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W04 LAB MOVIES ASSOCIATION:', () {
    testWidgets('support = 0.01.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await setPartition(tester, false);
      await loadDemoDataset(tester, 'Movies');
      await verifyRole('basket', 'Ident');
      await verifyRole('item', 'Target');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Associations', AssociationPanel);
      await verifyCheckbox(tester, 'Baskets', true);
      await enterText(tester, 'association_config_support', '0.01');
      await tapButton(tester, 'Build Association Rules');
      await navigateToPage(tester, 1, 'Association Rules — Meta Summary');
      await verifySelectableText(tester, ['support = 0.01']);
      await verifySelectableText(tester, ['117']);
    });
  });
}
