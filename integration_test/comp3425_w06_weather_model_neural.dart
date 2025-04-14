/// COMP3425 W06 WEATHER dataset MODEL tab NNET feature.
//
// Time-stamp: <Thursday 2025-04-10 12:22:23 +1000 Graham Williams>
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

import 'package:rattle/main.dart' as app;

import 'utils/enter_text.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';
import 'utils/set_selected_variable.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/tap_popup.dart';
import 'utils/verify_popup.dart';
import 'utils/verify_role.dart';

/// Specific variables with ROLE set to 'Ignore'.

final List<String> varsToIgnore = [
  'min_temp',
  'max_temp',
  'rainfall',
  'wind_gust_dir',
  'wind_gust_speed',
  'wind_dir_9am',
  'wind_dir_3pm',
  'wind_speed_3pm',
  'humidity_3pm',
  'pressure_3pm',
  'cloud_3pm',
  'rain_today',
  'rain_today',
  'risk_mm',
  'rain_tomorrow',
];

final List<String> inputVars = [
  'wind_speed_9am',
  'humidity_9am',
  'pressure_9am',
  'cloud_9am',
  'temp_9am',
];

final String targetVar = 'temp_3pm';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W06 LAB WEATHER NNET:', () {
    testWidgets('roles, ignore, cleanup, impute, rescale, nnet.',
        (WidgetTester tester) async {
      app.main();

      // Load the dataset and set variable roles.

      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Weather');
      for (final v in varsToIgnore) {
        await setDatasetRole(tester, v, 'Ignore');
      }
      for (final v in inputVars) {
        await verifyRole(v, 'Input');
      }
      await setDatasetRole(tester, targetVar, 'Target');
      await verifyRole(targetVar, 'Target');

      // Remove all IGNORED variables.

      await navigateToTab(tester, 'Transform');
      await navigateToFeature(tester, 'Cleanup');
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');
      await verifyPopup(varsToIgnore);
      await tapPopup(tester, 'Yes');

      // Impute missing clour_9am and remove the original.

      await navigateToFeature(tester, 'Impute');
      await setSelectedVariable(tester, 'cloud_9am');
      await tapChip(tester, 'Constant');
      await tapButton(tester, 'Impute Missing Values');
      await navigateToFeature(tester, 'Cleanup');
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');
      await tapPopup(tester, 'Yes');

      // Rescale [0-1] all variables, one at a time.

      await navigateToFeature(tester, 'Rescale');
      await tapChip(tester, 'Scale [0-1]');
      for (final v in inputVars) {
        if (v == 'cloud_9am') {
          await setSelectedVariable(tester, 'IMP_cloud_9am');
          await tapButton(tester, 'Rescale Variable Values');
        } else {
          await setSelectedVariable(tester, v);
          await tapButton(tester, 'Rescale Variable Values');
        }
      }
      await setSelectedVariable(tester, targetVar);
      await tapButton(tester, 'Rescale Variable Values');
      await navigateToFeature(tester, 'Cleanup');
      await tapChip(tester, 'Ignored');
      await tapButton(tester, 'Delete from Dataset');
      await tapPopup(tester, 'Yes');

      // Build neuralnet().

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Neural');
      await tapChip(tester, 'neuralnet');
      await enterText(tester, 'neuralnet_config_hidden_layers', '5,3');
      await tapButton(tester, 'Build Neural Network');

      // build nnet and neuralnet??

// evaluate either!!!
    });
  });
}
