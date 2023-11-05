/// Testing: Dataset Filename Selection
///
/// Time-stamp: <Sunday 2023-11-05 20:08:40 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/dataset_filename_test.dart

const String envPAUSE = String.fromEnvironment("PAUSE", defaultValue: "0");
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home page loads okay.', (WidgetTester tester) async {
    debugPrint("TESTER: Start up the app");

    app.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page.

    await tester.pump(pause);

    debugPrint("TESTER: Tap the Dataset button.");

    final datasetButton = find.byType(DatasetButton);
    expect(datasetButton, findsOneWidget);
    await tester.pump(pause);
    await tester.tap(datasetButton);
    await tester.pumpAndSettle();
    // Always delay here since if not the glimpse view is not available in
    // time! Odd but that's the result of experimenting. Have a delay after
    // the Demo buttons is pushed does not get the glimpse contents into the
    // widget.
    await tester.pump(delay);

    debugPrint("TESTER: Tap the Filename button.");

    final datasetPopup = find.byType(DatasetPopup);
    expect(datasetPopup, findsOneWidget);
    final filenameButton = find.text("Filename");
    expect(filenameButton, findsOneWidget);
    await tester.tap(filenameButton);
    await tester.pumpAndSettle();
    await tester.pump(pause);

    debugPrint("TESTER TODO: How to shutdown the file chooser popup?");

    debugPrint("TESTER: Finished.");
  });
}
