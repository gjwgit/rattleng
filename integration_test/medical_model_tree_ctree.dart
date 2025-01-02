/// Test the MODEL tab's TREE feature with the LARGE dataset.
//
// Time-stamp: <Monday 2024-10-14 08:34:17 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/number_field.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_dataset_by_path.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Large Model Tree CTree:', () {
    /// TODO 20240826 zy CONDITIONAL TREE NOT OPERATIOANL.
    ///
    /// Only testing UI functions.

    testWidgets('Load, Navigate.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDatasetByPath(tester, 'integration_test/medical.csv');

      // Tap the model Tab button.

      await navigateToTab(tester, 'Model');

      // Navigate to the Tree feature.

      await navigateToFeature(tester, 'Tree', TreePanel);

      // Find the ChoiceChipTip widget for the traditional algorithm type.

      final traditionalChip = find.text(
        'Traditional',
      );
      final conditionalChip = find.text('Conditional');

      // Verify that both chips exist in the widget tree.

      expect(traditionalChip, findsOneWidget);
      expect(conditionalChip, findsOneWidget);

      // Tap the conditional chip to switch algorithms.

      await tester.tap(conditionalChip);

      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Now switch back to the traditional algorithm.

      await tester.tap(traditionalChip);

      // Wait for the widget to rebuild and settle.

      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Tap the conditional chip to switch algorithms.

      await tester.tap(conditionalChip);

      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Verify the relevant fields are disabled when Conditional is selected.

      final complexityField = find.byKey(const Key('complexityField'));
      final priorsField = find.byKey(const Key('priorsField'));
      final lossMatrixField = find.byKey(const Key('lossMatrixField'));

      // Ensure that these fields are disabled (meaning that they are not accepting input).

      expect(tester.widget<NumberField>(complexityField).enabled, isFalse);
      expect(tester.widget<TextFormField>(priorsField).enabled, isFalse);
      expect(tester.widget<TextFormField>(lossMatrixField).enabled, isFalse);

      // Now switch back to the traditional algorithm.

      await tester.tap(traditionalChip);
      await tester.pumpAndSettle();
      await tester.pump(longHack);

      // Verify that the relevant fields are now enabled.

      expect(tester.widget<NumberField>(complexityField).enabled, isTrue);
      expect(tester.widget<TextFormField>(priorsField).enabled, isTrue);
      expect(tester.widget<TextFormField>(lossMatrixField).enabled, isTrue);

      await tester.pumpAndSettle();
      await tester.pump(interact);
    });
  });
}
