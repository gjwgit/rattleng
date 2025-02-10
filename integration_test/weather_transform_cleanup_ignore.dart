/// Test TRANSFORM tab CLEANUP feature IGNORE option on the DEMO dataset.
//
// Time-stamp: <Sunday 2025-02-09 05:50:11 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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
/// Authors: Yixiang Yin, Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/visual/panel.dart';

import 'package:rattle/main.dart' as app;
import 'package:rattle/features/cleanup/panel.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_popup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TRANSFORM CLEANUP IGNORE DEMO:', () {
    testWidgets('cleanup', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await setDatasetRole(tester, 'min_temp', 'Ignore');
      await setDatasetRole(tester, 'max_temp', 'Ignore');
      await setDatasetRole(tester, 'rainfall', 'Ignore');
      await navigateToTab(tester, 'Transform');
      await tester.pump(interact);
      await navigateToFeature(tester, 'Cleanup', CleanupPanel);
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');
      // Check that the variables to be deleted are mentioned in the popup.
      final deletedVariables = ['min_temp', 'max_temp', 'rainfall'];
      await verifyPopup(deletedVariables);

      // Confirm the deletion by tapping the "Yes" button.

      final yesButtonFinder = find.text('Yes');

      // Ensure the "Yes" button exists.

      expect(
        yesButtonFinder,
        findsOneWidget,
      );

      // Tap on the "Yes" button to confirm the deletion.

      await tester.tap(
        yesButtonFinder,
      );
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Go to the next page and confirm that the deleted variables are not
      // listed.

      await gotoNextPage(tester);

      // Check that deleted variables are not listed on the next page.

      for (String variable in deletedVariables) {
        final deletedVariableFinder = find.text(variable);

        // Ensure the deleted variable is not listed.

        expect(
          deletedVariableFinder,
          findsNothing,
        );
      }

      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Visual', VisualPanel);

      // Check that 'wind_gust_dir' is the selected variable.

      final evaporationSelectedFinder =
          find.text('wind_gust_dir').hitTestable();

      // Ensure 'wind_gust_dir' is selected.

      expect(
        evaporationSelectedFinder,
        findsOneWidget,
      );

      // Tap on the dropdown menu.

      await tester.tap(evaporationSelectedFinder);
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      await navigateToTab(tester, 'Dataset');
      await gotoNextPage(tester);
      await setDatasetRole(tester, 'wind_gust_dir', 'Ignore');
      await setDatasetRole(tester, 'wind_gust_speed', 'Ignore');
      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Cleanup', CleanupPanel);
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');
      await verifyPopup(['wind_gust_dir', 'wind_gust_speed']);

      // Pause after screen change.

      await tester.pump(interact);

      // Confirm the deletion by tapping the "Yes" button.

      await tester.tap(
        yesButtonFinder,
      );
      await tester.pumpAndSettle();

      // Pause after screen change.

      await tester.pump(interact);

      // Navigate to "EXPLORE" -> "VISUAL".

      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Visual', VisualPanel);

      // Pause after screen change.

      await tester.pump(interact);

      // Check that 'wind_speed_9am' is the selected variable.

      final windGustSpeedFinder = find.text('wind_speed_9am').hitTestable();
      expect(
        windGustSpeedFinder,
        findsOneWidget,
      );
    });
  });
}
