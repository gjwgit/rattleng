/// Explore page navigator after dataset reset.
//
// Time-stamp: <Wednesday 2024-08-28 09:17:11 +0800 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/dataset/popup.dart';

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/main.dart' as app;

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);
const Duration hack = Duration(seconds: 10);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Page Navigator Test After Dataset Reset:', () {
    testWidgets('Demo Dataset Page Navigator Test',
        (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      final datasetButtonFinder = find.byType(DatasetButton);

      await tester.tap(datasetButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final demoButton = find.text('Demo');
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);

      // Tap the right arrow button to go to the second page.

      await tester.tap(rightArrowFinder);

      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Tap the right arrow button to go to the third page.

      await tester.tap(rightArrowFinder);

      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Reload Demo Dataset.
      await tester.tap(datasetButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final resetDatasetButton = find.text('Yes');

      await tester.tap(resetDatasetButton);

      await tester.pumpAndSettle();

      await tester.pump(delay);

      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Tap the right arrow button to go to "Dataset Glimpse" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Find the text containing "366".

      final glimpseRowFinder = find.textContaining('366');
      expect(glimpseRowFinder, findsOneWidget);

      // Find the text containing "2007-11-01".

      final glimpseDateFinder = find.textContaining('2007-11-01');
      expect(glimpseDateFinder, findsOneWidget);

      // Tap the right arrow button to go to "ROLES" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Find the text containing "8.0".

      final rolesTempFinder = find.textContaining('8.0');
      expect(rolesTempFinder, findsOneWidget);
    });

    testWidgets('Demo/Large Dataset Page Navigator Test',
        (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      final datasetButtonFinder = find.byType(DatasetButton);

      await tester.tap(datasetButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);
      final demoButton = find.text('Demo');
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);

      // Tap the right arrow button to go to the second page.

      await tester.tap(rightArrowFinder);

      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Tap the right arrow button to go to the third page.

      await tester.tap(rightArrowFinder);

      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Reload large dataset.
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

      // Locate the TextField where the file path is input.

      final filePathField = find.byType(TextField);

      // Enter the file path programmatically.

      await tester.enterText(
        filePathField,
        'integration_test/rattle_test_large.csv',
      );

      // Simulate pressing the Enter key.

      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Optionally pump the widget tree to reflect the changes.
      await tester.pumpAndSettle();

      await tester.pump(pause);
      await tester.pump(hack);

      // Find the right arrow button in the PageIndicator.

      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to the second page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      final glimpseRowFinder = find.textContaining('Dataset Glimpse');
      expect(glimpseRowFinder, findsOneWidget);

      // Tap the right arrow button to go to the third  page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final rolesRecIDFinder = find.textContaining('Variable');
      expect(rolesRecIDFinder, findsOneWidget);

      await tester.pump(pause);
    });
  });
}
