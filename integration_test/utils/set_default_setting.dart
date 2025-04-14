/// Set the default settings.
//
// Time-stamp: <Thursday 2025-04-10 15:23:46 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/settings/dialog.dart';
import 'package:rattle/settings/sections/partition.dart';
import 'package:rattle/settings/sections/random_seed.dart';

import 'test_print.dart';

/// Load the dataset and undertake basic tests that it loaded just fine.

Future<void> setDefaultSetting(
  WidgetTester tester,
) async {
  // Open the settings dialog.

  final settingsButtonFinder = find.byKey(const Key('settings_button'));
  expect(settingsButtonFinder, findsOneWidget);

  await tester.tap(settingsButtonFinder);
  await tester.pumpAndSettle();

  // Verify the SettingsDialog is displayed.

  final settingsDialogFinder = find.byType(SettingsDialog);
  expect(settingsDialogFinder, findsOneWidget);

  testPrint('Opened the Settings Dialog.');

  // Find and tap the Dataset Toggles Reset button using its key.

  final datasetTogglesResetFinder =
      find.byKey(const Key('dataset_toggles_reset_button'));

  expect(datasetTogglesResetFinder, findsOneWidget);
  await tester.tap(datasetTogglesResetFinder);
  await tester.pumpAndSettle();

  testPrint('Tapped Dataset Toggles Reset Button.');

  // Find and tap the Random Seed Reset button.

  final randomSeedResetFinder = find.descendant(
    of: find.byType(RandomSeed),
    matching: find.widgetWithText(ElevatedButton, 'Reset'),
  );
  expect(randomSeedResetFinder, findsOneWidget);
  await tester.tap(randomSeedResetFinder);
  await tester.pumpAndSettle();
  testPrint('Tapped Random Seed Reset Button.');

  // Find and tap the Partition Reset button.

  final partitionResetFinder = find.descendant(
    of: find.byType(Partition),
    matching: find.widgetWithText(ElevatedButton, 'Reset'),
  );
  expect(partitionResetFinder, findsOneWidget);
  await tester.tap(partitionResetFinder);
  await tester.pumpAndSettle();
  testPrint('Tapped Partition Reset Button.');

  // Find and tap the Close button on the SettingsDialog.

  final closeButtonFinder = find.byIcon(Icons.close);
  expect(closeButtonFinder, findsOneWidget);
  await tester.tap(closeButtonFinder);
  await tester.pumpAndSettle();

  // Verify the SettingsDialog is closed.

  expect(find.byType(SettingsDialog), findsNothing);
  testPrint('Closed the Settings Dialog.');
}
