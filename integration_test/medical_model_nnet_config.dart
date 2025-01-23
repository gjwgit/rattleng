/// Model NNET test with large dataset.
//
// Time-stamp: <Friday 2025-01-24 08:53:56 +1100 Graham Williams>
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

import 'package:rattle/features/neural/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_dataset_role.dart';

/// List of specific variables that should have their role set to 'Ignore' in
/// large dataset. These are factors and don't play well with nnet.

final List<String> varsToIgnore = [
  'rec_id',
  'ssn',
  'first_name',
  'middle_name',
  'last_name',
  'birth_date',
  'medicare_number',
  'street_address',
  'suburb',
  'postcode',
  'phone',
  'email',
  'clinical_notes',
  'consultation_timestamp',
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Load, Ignore, Navigate, Configure, Build.', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDatasetByPath(tester, 'integration_test/medical.csv');

    for (final v in varsToIgnore) {
      await setDatasetRole(tester, v, 'Ignore');
    }

    await navigateToTab(tester, 'Model');
    await navigateToFeature(tester, 'Neural', NeuralPanel);

    // Find and tap the 'Trace' checkbox.

    final Finder traceCheckBox = find.byKey(const Key('NNET Trace'));
    await tester.tap(traceCheckBox);
    await tester.pumpAndSettle(); // Wait for UI to settle.

    // Find the text fields by their keys and enter the new values.

    await tester.enterText(find.byKey(const Key('hidden_neurons')), '11');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('max_NWts')), '10001');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('maxit')), '101');
    await tester.pumpAndSettle();

    // Simulate the presence of a decision tree being built.

    final neuralNetworkButton = find.byKey(const Key('Build Neural Network'));

    await tester.tap(neuralNetworkButton);
    await tester.pumpAndSettle();

    // await tester.pump(longHack);

    // Tap the right arrow to go to the second page.

    // await gotoNextPage(tester);

    await tester.pump(delay);

    // Check if SelectableText contains the expected content.

    final modelDescriptionFinder = find.byWidgetPredicate(
      (widget) =>
          widget is SelectableText &&
          widget.data?.contains('A 20-11-1 network with 243 weights') == true,
    );

    // Ensure the SelectableText widget with the expected content exists.

    // TODO 20241001 kev : underneath code is not working as expected
    expect(modelDescriptionFinder, findsOneWidget);

    final summaryDecisionTreeFinder = find.byType(TextPage);
    expect(summaryDecisionTreeFinder, findsOneWidget);

    await tester.pump(interact);

    final optionsDescriptionFinder = find.byWidgetPredicate(
      (widget) =>
          widget is SelectableText &&
          widget.data?.contains(
                'Options were - entropy fitting.',
              ) ==
              true,
    );

    // Ensure the SelectableText widget with the expected content exists.

    expect(optionsDescriptionFinder, findsOneWidget);

    await tester.pump(interact);

    // Tap the right arrow to go to the forth page.

    await gotoNextPage(tester);

    await tester.pump(hack);

    final forthPageTitleFinder = find.text('Neural Net Model - Visual');
    expect(forthPageTitleFinder, findsOneWidget);

    final imageFinder = find.byType(ImagePage);

    // Assert that the image is present.
    expect(imageFinder, findsOneWidget);

    await tester.pump(interact);
  });
}
