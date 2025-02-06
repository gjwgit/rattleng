/// AUDIT dataset TRANSFORM tab IMPUTE feature.
//
// Time-stamp: <2025-02-06 20:15:41 gjw>
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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
/// Authors:  Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/impute/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_selected_variable.dart';
import 'utils/tap_button.dart';

import 'utils/unify_on.dart';

import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AUDIT TRANSFORM IMPUTE:', () {
    testWidgets('occupation.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await unifyOn(tester);
      await loadDemoDataset(tester, 'Audit');
      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Impute', ImputePanel);
      await setSelectedVariable(tester, 'occupation');
      await tapButton(tester, 'Impute Missing Values');
      await tester.pump(delay);
      await gotoNextPage(tester);
      await verifyPage(
        'Dataset Summary',
        'IMO_occupation',
      );
      await verifySelectableText(
        tester,
        [
	  'Executive   :390',
	  'Professional:247',
	  'Clerical    :232',
	  'Repair      :225',
	  'Service     :210', 
	  'Sales       :206',
        ],
      );
    });
  });
}
