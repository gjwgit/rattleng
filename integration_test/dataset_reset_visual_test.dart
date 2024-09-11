/// Test visual image disappear after the DATASET RESET.
//
// Time-stamp: <Saturday 2024-09-07 06:20:19 +1000 Graham Williams>
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
import 'package:rattle/features/dataset/panel.dart';
import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/model.dart';
import 'package:rattle/widgets/image_page.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/open_large_dataset.dart';
import 'utils/press_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dataset Reset and Image Disappear:', () {
    testWidgets('demo tree image disappear.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDemoDataset(tester);
      await navigateToPage(
        tester,
        Icons.model_training,
        ModelTabs,
      );

      await navigateToFeature(tester, 'Tree', TreePanel);

      await pressButton(tester, 'Build Decision Tree');

      final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();
      await tester.pump(hack);

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Tap the right arrow to go to the forth page.

      await tester.tap(rightArrowButton);
      await tester.pumpAndSettle();

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.
      expect(imageFinder, findsOneWidget);

      await navigateToPage(
        tester,
        Icons.input,
        DatasetPanel,
      );

      // Clear dataset.

      final datasetButton = find.byType(DatasetButton);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      final resetDatasetButton = find.text('Yes');
      await tester.tap(resetDatasetButton);
      await tester.pumpAndSettle();

      final cancelButton = find.text('Cancel');

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      await navigateToPage(
        tester,
        Icons.model_training,
        ModelTabs,
      );

      await navigateToFeature(tester, 'Tree', TreePanel);
      // Find the TabPageSelector and check its page count.
      final tabPageSelectorFinder = find.byType(TabPageSelector);
      expect(tabPageSelectorFinder, findsOneWidget);

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

  testWidgets('large dataset tree image disappear.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(pause);

    await openLargeDataset(tester);
    await navigateToPage(
      tester,
      Icons.model_training,
      ModelTabs,
    );

    await navigateToFeature(tester, 'Tree', TreePanel);

    await pressButton(tester, 'Build Decision Tree');

    final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);

    await tester.tap(rightArrowButton);
    await tester.pumpAndSettle();
    await tester.pump(hack);

    await tester.tap(rightArrowButton);
    await tester.pumpAndSettle();

    await tester.pump(hack);

    // Tap the right arrow to go to the forth page.

    await tester.tap(rightArrowButton);
    await tester.pumpAndSettle();
    await tester.pump(hack);

    final imageFinder = find.byType(ImagePage);

    // Assert that the image is present.
    expect(imageFinder, findsOneWidget);

    await navigateToPage(
      tester,
      Icons.input,
      DatasetPanel,
    );

    // Clear dataset.

    final datasetButton = find.byType(DatasetButton);
    await tester.tap(datasetButton);
    await tester.pumpAndSettle();

    final resetDatasetButton = find.text('Yes');
    await tester.tap(resetDatasetButton);
    await tester.pumpAndSettle();

    final cancelButton = find.text('Cancel');

    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    await navigateToPage(
      tester,
      Icons.model_training,
      ModelTabs,
    );

    await navigateToFeature(tester, 'Tree', TreePanel);
    // Find the TabPageSelector and check its page count.
    final tabPageSelectorFinder = find.byType(TabPageSelector);
    expect(tabPageSelectorFinder, findsOneWidget);

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
