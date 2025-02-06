/// WEATHER dataset TRANSFORM tab CLEANUP feature.
//
// Time-stamp: <Tuesday 2025-02-04 10:34:15 +1100 Graham Williams>
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
/// Authors:  Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/cleanup/panel.dart';

import 'package:rattle/main.dart' as app;

import 'utils/check_popup.dart';
import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_chip.dart';
import 'utils/tap_button.dart';
import 'utils/unify_on.dart';
import 'utils/tap_yes.dart';

import 'utils/set_four_var_ignore.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WEATHER TRANSFORM CLEANUP:', () {
    testWidgets('min_temp.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await unifyOn(tester);
      await loadDemoDataset(tester);
      await tester.pump(delay);

      await setFourVarIgnore(tester);

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Cleanup', CleanupPanel);
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');

      // Check that the variables to be deleted are mentioned in the popup.

      checkInPopup(['date', 'min_temp', 'max_temp', 'rainfall']);

      await tapYes(tester);
    });
  });
}
