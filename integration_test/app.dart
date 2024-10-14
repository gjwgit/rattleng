/// Test that the app starts up.
//
// Time-stamp: <Monday 2024-10-14 13:41:24 +1100 Graham Williams>
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

import 'dart:io';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';

import 'utils/delays.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App Startup.', (WidgetTester tester) async {
    app.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page during an interactive test. We use a
    // [interact] delay which for qtest is 0s and for itest is 5s. Lutra-fs
    // notes that 0s is problematic on their testing (hence qtest
    // failing). Perhaps then try with itest.

    await tester.pump(interact);

    // Check that there is DATASET BUILD button.

    final datasetButtonFinder = find.byType(DatasetButton);
    expect(datasetButtonFinder, findsOneWidget);

    await tester.pump(interact);

    // Confirm the 2 Markdown widgets.

    final welcomeMarkdownFinder = find.byType(Markdown);
    expect(welcomeMarkdownFinder, findsNWidgets(3));

    // The first is the first panel of the welcome widget. We can check it's
    // contents is as expected.

    final welcomeWidget =
        welcomeMarkdownFinder.evaluate().first.widget as Markdown;

    // Read the file content and normalize whitespace.

    String expectedwelcome1Content = File('assets/markdown/welcome1.md')
        .readAsStringSync()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    String actualwelcome1Content =
        welcomeWidget.data.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Perform the comparison.

    expect(actualwelcome1Content, expectedwelcome1Content);

    final welcome2Widget =
        welcomeMarkdownFinder.evaluate().elementAt(1).widget as Markdown;

    // welcome2.md is the second panel of the welcome widget.
    // Read the file content and normalize whitespace.

    String expectedwelcome2Content = File('assets/markdown/welcome2.md')
        .readAsStringSync()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    String actualwelcome2Content =
        welcome2Widget.data.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Perform the comparison.

    if (actualwelcome2Content.contains('No **Dataset** loaded')) {
      print('Dataset not loaded, skipping Markdown content check.');
    } else {
      expect(actualwelcome2Content, expectedwelcome2Content);
    }

    // Check that we have a single status bar.

    final statusBarFinder = find.byKey(statusBarKey);
    expect(statusBarFinder, findsOneWidget);
  });
}
