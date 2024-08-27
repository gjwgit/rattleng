/// CLUSTER feature.
//
// Time-stamp: <Tuesday 2024-08-20 20:05:55 +1000 Graham Williams>
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

/// 20230712 gjw We use a PAUSE duration to allow the tester to view/interact
/// with the testing. 5s is good, 10s is useful for development and 0s for
/// ongoing. This is not necessary but it is handy when running interactively
/// for the user running the test to see the widgets for added assurance. The
/// PAUSE environment variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cluster Feature:', () {
    testWidgets('Demo Dataset, Model, Cluster.', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      expect(datasetButton, findsOneWidget);

      await tester.pump(pause);

      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);

      final demoButton = find.text('Demo');
      expect(demoButton, findsOneWidget);

      await tester.tap(demoButton);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the Model tab by icon and tap on it.

      final modelIconFinder = find.byIcon(Icons.model_training);
      expect(modelIconFinder, findsOneWidget);

      // Tap the Model tab.

      await tester.tap(modelIconFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Verify if the ModelTabs widget is shown.

      expect(find.byType(ModelTabs), findsOneWidget);

      // Navigate to the Cluster feature.

      final clusterTabFinder = find.text('Cluster');
      await tester.tap(clusterTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the BUILD button by its text.

      final buildButtonFinder = find.text('Build Clustering');
      expect(buildButtonFinder, findsOneWidget);

      // Tap the button.

      await tester.tap(buildButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to the first page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing the number of default clusters.

      final dateFinder = find.textContaining('with 10 clusters');
      expect(dateFinder, findsOneWidget);
    });
  });
}
