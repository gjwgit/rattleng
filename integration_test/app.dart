/// Test APP starts up.
//
// Time-stamp: <Friday 2025-01-17 16:30:22 +1100 Graham Williams>
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

    // Confirm the Markdown widgets.

    final welcomeMarkdownFinder = find.byType(Markdown);
    expect(welcomeMarkdownFinder, findsNWidgets(2));

    // The first Markdown widget is the first panel of the welcome widget with
    // text frm welcome1.md that we can check is the same as dislayed by reading
    // the file content and normalizing whitespace.

    final welcomeWidget =
        welcomeMarkdownFinder.evaluate().first.widget as Markdown;

    String expectedwelcome1Content = File('assets/markdown/welcome1.md')
        .readAsStringSync()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    String actualwelcome1Content =
        welcomeWidget.data.replaceAll(RegExp(r'\s+'), ' ').trim();

    expect(actualwelcome1Content, expectedwelcome1Content);

    // The second Markdown widget should be the second part of the welcome
    // message, with welcome2.md as the second panel of the welcome widget.
    // Read the file content and normalize whitespace.

    final welcome2Widget =
        welcomeMarkdownFinder.evaluate().elementAt(1).widget as Markdown;

    String expectedwelcome2Content = File('assets/markdown/welcome2.md')
        .readAsStringSync()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    String actualwelcome2Content =
        welcome2Widget.data.replaceAll(RegExp(r'\s+'), ' ').trim();

    expect(actualwelcome2Content, expectedwelcome2Content);

    // Also check that we have a single status bar.

    final statusBarFinder = find.byKey(statusBarKey);
    expect(statusBarFinder, findsOneWidget);
  });
}
