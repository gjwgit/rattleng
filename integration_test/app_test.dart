/// Testing: Basic app startup test.
///
/// Copyright (C) 2023, Software Innovation Institute, ANU.
///
/// License: http://www.apache.org/licenses/LICENSE-2.0
///
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///
/// Authors: Graham Williams

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as rattle;
import 'package:rattle/dataset/button.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
///
/// 20230712 gjw

const String envPAUSE = String.fromEnvironment("PAUSE", defaultValue: "0");
final Duration pause = Duration(seconds: int.parse(envPAUSE));
final Duration delay = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home page loads okay.', (WidgetTester tester) async {
    debugPrint("TESTER: Start up the app");

    rattle.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page.

    await tester.pump(pause);

    debugPrint("TESTER: Verify various expected home page widgets.");

    final datasetButtonFinder = find.byType(DatasetButton);
    expect(datasetButtonFinder, findsOneWidget);
    await tester.pump(pause);

    final welcomeTextFinder = find.byKey(welcomeTextKey);
    expect(welcomeTextFinder, findsOneWidget);

    // TODO Check we have a X and the two toggles for normalise and partition.

    debugPrint("TESTER: Confirm welcome message on home screen.");

    // Confirm the introductory text is as expected from the welcome.md
    // file. We find all the Markdown widgets (currently 20231008 there are 2)
    // and get the first one, hopefully as the welcome widget? Instead of
    // findNWidgets(2) we could use findAtLeastNWidgets(2).

    final welcomeMarkdownFinder = find.byType(Markdown);
    expect(welcomeMarkdownFinder, findsNWidgets(2));

    final welcomeWidget =
        welcomeMarkdownFinder.evaluate().first.widget as Markdown;
    String welcome = welcomeWidget.data;
    expect(welcome, File('assets/markdown/welcome.md').readAsStringSync());

    debugPrint("TESTER TODO: Check the status bar has the expected contents.");

    final statusBarFinder = find.byKey(statusBarKey);
    expect(statusBarFinder, findsOneWidget);

    debugPrint("TESTER: Finished.");
  });
}
