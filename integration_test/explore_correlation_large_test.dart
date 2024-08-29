/// EXPLORE tab: Correlation Large Dataset Test.
//
// Time-stamp: <Tuesday 2024-08-20 16:43:07 +1000 Graham Williams>
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
/// Authors:  Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/correlation/panel.dart';

import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/explore.dart';

import 'helper.dart';
// import '600_explore_large_test.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration hack = Duration(seconds: 5);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Tab:', () {
    testWidgets('Large Dataset, Explore, Correlation.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await _openLargeDataset(tester);
      await navigateToExploreTab(tester);

      await navigateToTab(tester, 'Correlation', CorrelationPanel);

      await performCorrelationAnalysis(tester);

      // Verify the content of the page 1.

      await verifyPageContent(tester, 'Correlation - Numeric Data', '1.00');
      await verifyTextContent(tester, '0.39');
      await verifyTextContent(tester, '0.01');
      await verifyTextContent(tester, '0.53');

      await verifyPageContent(tester, 'Variable Correlation Plot');
    });
  });
}

Future<void> _openLargeDataset(WidgetTester tester) async {
  // Locate the TextField where the file path is input.

  final filePathField = find.byType(TextField);
  expect(filePathField, findsOneWidget);

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
}
