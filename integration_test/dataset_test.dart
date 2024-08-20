/// Testing: Basic app startup test.
//
// Time-stamp: <Tuesday 2024-08-20 15:46:43 +1000 Graham Williams>
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/tabs/explore.dart';

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

  testWidgets('Home page loads okay.', (WidgetTester tester) async {
    debugPrint('DATASET: Start up the app');

    app.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page.

    await tester.pump(pause);

    final datasetButtonFinder = find.byType(DatasetButton);
    expect(datasetButtonFinder, findsOneWidget);
    await tester.pump(pause);

    debugPrint('DATASET: Confirm welcome message on home screen.');

    final welcomeMarkdownFinder = find.byType(Markdown);
    expect(welcomeMarkdownFinder, findsNWidgets(2));

    final welcomeWidget =
        welcomeMarkdownFinder.evaluate().first.widget as Markdown;
    String welcome = welcomeWidget.data;
    expect(welcome, File('assets/markdown/welcome.md').readAsStringSync());

    debugPrint('Check the status bar has the expected contents.');

    final statusBarFinder = find.byKey(statusBarKey);
    expect(statusBarFinder, findsOneWidget);

    ////////////////////////////////////////////////////////////////////////
    // DATASET DEMO (By Kevin)
    ////////////////////////////////////////////////////////////////////////

    debugPrint('DATASET: Tap the Dataset button.');

    final datasetButton = find.byType(DatasetButton);
    expect(datasetButton, findsOneWidget);
    await tester.tap(datasetButton);
    await tester.pumpAndSettle();

    await tester.pump(pause);

    debugPrint('DATASET: Tap the Demo button.');

    final datasetPopup = find.byType(DatasetPopup);
    expect(datasetPopup, findsOneWidget);
    final demoButton = find.text('Demo');
    expect(demoButton, findsOneWidget);
    await tester.tap(demoButton);
    await tester.pumpAndSettle();
    await tester.pump(pause);

    debugPrint('DATASET: Expect the default demo dataset is identified.');

    final dsPathTextFinder = find.byKey(datasetPathKey);
    expect(dsPathTextFinder, findsOneWidget);
    final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
    String filename = dsPathText.controller?.text ?? '';
    expect(filename, 'rattle::weather');

    debugPrint('DATASET: Expect the default demo dataset is loaded.');

    // @KEVIN PLEASE TEST THE GLIMPSE PAGE AND THE ROLES PAGE

    debugPrint('DATASET: Finished.');
  });
}
