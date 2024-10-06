/// CLUSTER feature.
//
// Time-stamp: <2024-10-05 17:45:55 gjw>
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
/// Authors: Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/tabs/model.dart';

import 'utils/delays.dart';
import 'utils/open_demo_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cluster Feature:', () {
    testWidgets('Demo Dataset, Model, Cluster.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(interact);

      await openDemoDataset(tester);

      // Find the Model tab by icon and tap on it.

      final modelIconFinder = find.byIcon(Icons.model_training);
      expect(modelIconFinder, findsOneWidget);

      // Tap the Model tab.

      await tester.tap(modelIconFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Verify if the ModelTabs widget is shown.

      expect(find.byType(ModelTabs), findsOneWidget);

      // Navigate to the Cluster feature.

      final clusterTabFinder = find.text('Cluster');
      await tester.tap(clusterTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the BUILD button by its text.

      final buildButtonFinder = find.text('Build Clustering');
      expect(buildButtonFinder, findsOneWidget);

      // Tap the button.

      await tester.tap(buildButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      await tester.tap(buildButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Find the text containing the number of default clusters.

      final dateFinder = find.textContaining('with 10 clusters');
      expect(dateFinder, findsOneWidget);
    });
  });
}
