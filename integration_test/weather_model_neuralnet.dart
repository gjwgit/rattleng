/// Test neuralnet() with demo dataset.
//
// Time-stamp: <Monday 2025-03-24 12:27:25 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/set_dataset_role.dart';
import 'utils/tap_button.dart';
import 'utils/verify_role.dart';
import 'utils/verify_selectable_text.dart';

// List of specific variables that should have their role set to 'Ignore' in
// demo dataset. These are factors/chars and don't play well with nnet.

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

  group('Demo Model Neuralnet:', () {
    testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
      app.main();
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
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Neural');
      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Find the ChoiceChipTip widget for the algorithm type.

      final neuralnetChip = find.text(
        'neuralnet',
      );

      // Tap the neuralnet chip to switch algorithm.

      await tester.tap(neuralnetChip);
      await tester.pumpAndSettle();

      await tapButton(tester, 'Build Neural Network');
      // We need quite a long delay here to have the model built. On Kadesh it
      // required 6s delay but on ecosysl it required 16s! (gjw 20250323)
      await addDelay(16);
      await navigateToPage(tester, 1);
      await verifySelectableText(
        tester,
        [
          'data = ds_final',
        ],
      );
    });
  });
}
