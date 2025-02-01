/// Test visual image disappear after the DATASET RESET.
//
// Time-stamp: <Sunday 2025-02-02 06:00:35 +1100 Graham Williams>
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

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dataset Reset and Image Disappear:', () {
    testWidgets('demo tree image disappear.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDemoDataset(tester);
      await tester.pump(hack);

      await navigateToTab(tester, 'Model');

      await navigateToFeature(tester, 'Tree', TreePanel);

      await tapButton(tester, 'Build Decision Tree');
      await tester.pump(hack);

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      await tester.pump(hack);

      // Tap the right arrow to go to the forth page.

      // await tester.tap(rightArrowButton);
      // await tester.pumpAndSettle();
      // await tester.pump(hack);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await navigateToTab(tester, 'Dataset');

      // Clear dataset.

      final datasetButton = find.byType(DatasetButton);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      final resetDatasetButton = find.text('Yes');
      await tester.tap(resetDatasetButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      final cancelButton = find.text('Cancel');

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await navigateToTab(tester, 'Model');

      await navigateToFeature(tester, 'Tree', TreePanel);

      // Assuming the TabPageSelector's page count is based on a PageController.
      final pageControllerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is PageView &&
            widget.controller != null &&
            widget.controller!.page == 0.0,
      );

      expect(pageControllerFinder, findsOneWidget);
    });
  });

  testWidgets('large dataset tree image disappear.', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(interact);
    await loadDatasetByPath(tester, 'integration_test/data/medical.csv');
    await navigateToTab(tester, 'Model');
    await navigateToFeature(tester, 'Tree', TreePanel);
    await tapButton(tester, 'Build Decision Tree');
    await tester.pump(hack);
    await gotoNextPage(tester);
    await gotoNextPage(tester);

    final imageFinder = find.byType(ImagePage);
    expect(imageFinder, findsOneWidget);

    await navigateToTab(tester, 'Dataset');

    // Clear dataset.

    final datasetButton = find.byType(DatasetButton);
    await tester.tap(datasetButton);
    await tester.pumpAndSettle();
    await tester.pump(hack);

    final resetDatasetButton = find.text('Yes');
    await tester.tap(resetDatasetButton);
    await tester.pumpAndSettle();
    await tester.pump(hack);

    final cancelButton = find.text('Cancel');

    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
    await tester.pump(hack);

    await navigateToTab(tester, 'Model');
    await tester.pump(hack);

    await navigateToFeature(tester, 'Tree', TreePanel);

    // Assuming the TabPageSelector's page count is based on a PageController
    final pageControllerFinder = find.byWidgetPredicate(
      (widget) =>
          widget is PageView &&
          widget.controller != null &&
          widget.controller!.page == 0.0,
    );

    expect(pageControllerFinder, findsOneWidget);
  });
}
