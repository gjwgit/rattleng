/// Testing: Basic app startup test.
//
// Time-stamp: <Tuesday 2024-08-20 16:43:38 +1000 Graham Williams>
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

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';

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
  // TODO 20240820 gjw IS THIS NEEDED?
  //
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TODO 20240820 gjw KEVIN/ZHEYUAN SPLIT INTO TWO GROUPS: WELCOME and DEMO

  group('App Startup:', () {
    testWidgets('Home Page.', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the result.

      await tester.pump(pause);

      // Confirm welcome message on home screen.

      final welcomeMarkdownFinder = find.byType(Markdown);
      expect(welcomeMarkdownFinder, findsNWidgets(2));

      final welcomeWidget =
          welcomeMarkdownFinder.evaluate().first.widget as Markdown;
      String welcome = welcomeWidget.data;
      expect(welcome, File('assets/markdown/welcome.md').readAsStringSync());

      // Find the DATASET button to tap to load a dataset.

      final datasetButtonFinder = find.byType(DatasetButton);
      expect(datasetButtonFinder, findsOneWidget);
      await tester.pump(pause);

      // Check the status bar has the expected contents.

      final statusBarFinder = find.byKey(statusBarKey);
      expect(statusBarFinder, findsOneWidget);
    });
  });
}
