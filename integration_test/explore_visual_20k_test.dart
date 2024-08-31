/// Explore tab Visual feature Large dataset.
//
// Time-stamp: <Tuesday 2024-08-27 20:54:02 +0800 Graham Williams>
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
/// Authors: Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/visual/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/explore.dart';

/// 20230712 gjw We use a PAUSE duration to allow the tester to view/interact
/// with the testing. 5s is good, 10s is useful for development and 0s for
/// ongoing. This is not necessary but it is handy when running interactively
/// for the user running the test to see the widgets for added assurance. The
/// PAUSE environment variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 5);
const Duration hack = Duration(seconds: 10);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore tab Large dataset:', () {
    testWidgets('Visual feature.', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      // Locate the TextField where the file path is input.

      final filePathField = find.byType(TextField);
      expect(filePathField, findsOneWidget);

      // Enter the file path programmatically.

      await tester.enterText(
        filePathField,
        'integration_test/rattle_test_20k.csv',
      );

      // Simulate pressing the Enter key.

      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Optionally pump the widget tree to reflect the changes.
      await tester.pumpAndSettle();

      await tester.pump(delay);

      // Find the Explore tab by icon and tap on it.

      final exploreIconFinder = find.byIcon(Icons.insights);
      expect(exploreIconFinder, findsOneWidget);

      // Tap the Explore tab.

      await tester.tap(exploreIconFinder);
      await tester.pumpAndSettle();

      // Verify if the ExploreTabs widget is shown.

      expect(find.byType(ExploreTabs), findsOneWidget);

      // Navigate to the Explore tab.

      final exploreTabFinder = find.text('Explore');
      await tester.tap(exploreTabFinder);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      ////////////////////////////////////////////////////////////////////////
      // Visual page
      ////////////////////////////////////////////////////////////////////////

      final visualTabFinder = find.text('Visual');
      expect(visualTabFinder, findsOneWidget);

      // Tap the Visual tab.

      await tester.tap(visualTabFinder);
      await tester.pumpAndSettle();

      // Verify that the VisualPanel is shown.

      expect(find.byType(VisualPanel), findsOneWidget);

      await tester.pump(pause);
      await tester.pump(delay);

      // Find the button by its text.

      final generatePlotButtonFinder = find.text('Generate Plots');
      expect(generatePlotButtonFinder, findsOneWidget);

      // Tap the button.

      await tester.tap(generatePlotButtonFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Find the right arrow button in the PageIndicator.

      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to "Box Plot" page 2.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Box Plot".

      final boxPlotFinder = find.textContaining('Box Plot');
      expect(boxPlotFinder, findsOneWidget);

      // TODO 20240827 gjw SOME PLOT TEST IDEAS
      //
      // Can we read the generated SVG file properties to ensure the plot has
      // just been generated and the size is abuotwhat we expect it to be.

      // Tap the right arrow button to go to "Density Plot of Values" page 3.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Density Plot of Values".

      final densityPlotFinder = find.textContaining('Density Plot of Values');
      expect(densityPlotFinder, findsOneWidget);

      // Tap the right arrow button to go to "Cumulative Plot" page 4.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Cumulative Plot".

      final cumulativePlotFinder = find.textContaining('Cumulative Plot');
      expect(cumulativePlotFinder, findsOneWidget);

      // Tap the right arrow button to go to "Benford Plots" page 5.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      // Find the text containing "Benford Plot".

      final benfordPlotFinder = find.textContaining('Benford Plot');
      expect(benfordPlotFinder, findsOneWidget);
    });
  });
}
