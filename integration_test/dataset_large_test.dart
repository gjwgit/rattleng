/// Testing: large dataset test(Confirm GLIMPSE and ROLES pages).
//
// Time-stamp: <Thursday 2024-08-22 08:18:13 +1000 Graham Williams>
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
/// Authors: Graham Williams, Kevin Wang
library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

// TODO 20231015 gjw MIGRATE TESTS TO SINGLE ONE APP INSTANCE
//
// This will avoid a costly build each individual test? But then it is not so
// well strctured.

// TODO 20231015 gjw MIGRATE ALL TESTS TO THE ONE APP INSTANCE RATHER THAN A
// COSTLY BUILD EACH INDIVIDUAL TEST!

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
///
/// 20230712 gjw

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Large Dataset, GLIMPSE and ROLES pages',
      (WidgetTester tester) async {
    app.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page.

    await tester.pump(pause);

    // final datasetButtonFinder = find.byType(DatasetButton);
    // expect(datasetButtonFinder, findsOneWidget);
    // await tester.pump(pause);

    // final datasetButton = find.byType(DatasetButton);
    // expect(datasetButton, findsOneWidget);
    // await tester.pump(pause);
    // await tester.tap(datasetButton);
    // await tester.pumpAndSettle();

    // await tester.pump(delay);

    // // final datasetPopup = find.byType(DatasetPopup);
    // // expect(datasetPopup, findsOneWidget);
    // final filenameButton = find.text('Filename');
    // // expect(filenameButton, findsOneWidget);
    // // await tester.tap(filenameButton);
    // // await tester.pumpAndSettle();
    // // await tester.pump(const Duration(seconds: 10));
    // // await tester.pumpAndSettle();

    // final datasetPopup = find.byType(DatasetPopup);
    // expect(datasetPopup, findsOneWidget);

// Locate the TextField where the file path is input.
    final filePathField = find.byType(TextField);
    expect(filePathField, findsOneWidget);

// Enter the file path programmatically.
    await tester.enterText(
      filePathField,
      'integration_test/rattle_test_large.csv',
    );

    // Simulate pressing the Enter key
    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Optionally pump the widget tree to reflect the changes.
    await tester.pumpAndSettle();

    await tester.pump(pause);

    // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
    //
    // How do we ensure the R Code is executed before proceeding in Rattle
    // itself - deal with the async issue.

    await tester.pump(const Duration(seconds: 10));

//     await tester.tap(filenameButton); // If the button opens the file picker
//     await tester.pumpAndSettle();

// // Now locate and interact with the TextField as above.

//     await tester.enterText(
//         filePathField, '/Users/kev/Desktop/rattle_test_large.csv');
//     await tester.pumpAndSettle();

//     ////////////////////////////////////////////////////////////////////////
//     // DATASET Large DATASET tab (GLIMPSE and ROLES pages) (By Kevin)
//     ////////////////////////////////////////////////////////////////////////

    // Find the right arrow button in the PageIndicator.

    final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
    expect(rightArrowFinder, findsOneWidget);

    // Tap the right arrow button to go to "Dataset Glimpse" page.

    await tester.tap(rightArrowFinder);
    await tester.pumpAndSettle();

    await tester.pump(pause);

    // Find the text containing "24".

    final glimpseColumnFinder = find.textContaining('24');
    expect(glimpseColumnFinder, findsOneWidget);

    // // Tap the right arrow button to go to "ROLES" page.

    // await tester.tap(rightArrowFinder);
    // await tester.pumpAndSettle();

    // // Find the text containing "rec-57600".

    // final rolesRecIDFinder = find.textContaining('rec-57600');
    // expect(rolesRecIDFinder, findsOneWidget);
  });
}
