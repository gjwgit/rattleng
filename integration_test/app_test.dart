// /// Testing: Basic app startup test.
// ///
// /// Copyright (C) 2023, Software Innovation Institute, ANU.
// ///
// /// License: http://www.apache.org/licenses/LICENSE-2.0
// ///
// // Licensed under the Apache License, Version 2.0 (the "License");
// // you may not use this file except in compliance with the License.
// //
// // Unless required by applicable law or agreed to in writing, software
// // distributed under the License is distributed on an "AS IS" BASIS,
// // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// // See the License for the specific language governing permissions and
// // limitations under the License.
// ///
// /// Authors: Graham Williams

// // TODO 20231015 gjw MIGRATE ALL TESTS TO THE ONE APP INSTANCE RATHER THAN A
// // COSTLY BUILD EACH INDIVIDUAL TEST!

// import 'dart:io';

// import 'package:flutter/material.dart';

// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:integration_test/integration_test.dart';

// import 'package:rattle/constants/keys.dart';
// import 'package:rattle/main.dart' as app;
// import 'package:rattle/features/dataset/button.dart';
// import 'package:rattle/features/dataset/popup.dart';

// /// A duration to allow the tester to view/interact with the testing. 5s is
// /// good, 10s is useful for development and 0s for ongoing. This is not
// /// necessary but it is handy when running interactively for the user running
// /// the test to see the widgets for added assurance. The PAUSE environment
// /// variable can be used to override the default PAUSE here:
// ///
// /// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
// ///
// /// 20230712 gjw

// const String envPAUSE = String.fromEnvironment("PAUSE", defaultValue: "0");
// final Duration pause = Duration(seconds: int.parse(envPAUSE));
// const Duration delay = Duration(seconds: 1);

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('Home page loads okay.', (WidgetTester tester) async {
//     debugPrint("TESTER: Start up the app");

//     app.main();

//     // Trigger a frame. Finish animation and scheduled microtasks.

//     await tester.pumpAndSettle();

//     // Leave time to see the first page.

//     await tester.pump(pause);

//     debugPrint("TESTER: Verify various expected home page widgets.");

//     final datasetButtonFinder = find.byType(DatasetButton);
//     expect(datasetButtonFinder, findsOneWidget);
//     await tester.pump(pause);

//     final welcomeTextFinder = find.byKey(welcomeTextKey);
//     expect(welcomeTextFinder, findsOneWidget);

//     // TODO Check we have a X and the two toggles for normalise and partition.

//     debugPrint("TESTER: Confirm welcome message on home screen.");

//     // Confirm the introductory text is as expected from the welcome.md
//     // file. We find all the Markdown widgets (currently 20231008 there are 2)
//     // and get the first one, hopefully as the welcome widget? Instead of
//     // findNWidgets(2) we could use findAtLeastNWidgets(2).

//     final welcomeMarkdownFinder = find.byType(Markdown);
//     expect(welcomeMarkdownFinder, findsNWidgets(2));

//     final welcomeWidget =
//         welcomeMarkdownFinder.evaluate().first.widget as Markdown;
//     String welcome = welcomeWidget.data;
//     expect(welcome, File('assets/markdown/welcome.md').readAsStringSync());

//     debugPrint("TESTER TODO: Check the status bar has the expected contents.");

//     final statusBarFinder = find.byKey(statusBarKey);
//     expect(statusBarFinder, findsOneWidget);

//     ////////////////////////////////////////////////////////////////////////
//     // DATASET DEMO
//     ////////////////////////////////////////////////////////////////////////

//     debugPrint("TESTER: Tap the Dataset button.");

//     final datasetButton = find.byType(DatasetButton);
//     expect(datasetButton, findsOneWidget);
//     await tester.pump(pause);
//     await tester.tap(datasetButton);
//     await tester.pumpAndSettle();
//     // Always delay here since if not the glimpse view is not available in
//     // time! Odd but that's the result of experimenting. Have a delay after
//     // the Demo buttons is pushed does not get the glimpse contents into the
//     // widget.
//     await tester.pump(delay);

//     debugPrint("TESTER: Tap the Demo button.");

//     final datasetPopup = find.byType(DatasetPopup);
//     expect(datasetPopup, findsOneWidget);
//     final demoButton = find.text("Demo");
//     expect(demoButton, findsOneWidget);
//     await tester.tap(demoButton);
//     await tester.pumpAndSettle();
//     await tester.pump(pause);

//     debugPrint("TESTER: Expect the default demo dataset is identified.");

//     final dsPathTextFinder = find.byKey(datasetPathKey);
//     expect(dsPathTextFinder, findsOneWidget);
//     final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
//     String filename = dsPathText.controller?.text ?? '';
//     expect(filename, "rattle::weather");

//     debugPrint("TESTER: Check welcome hidden and dataset is visible.");

//     final datasetFinder = find.byType(Visibility);
//     expect(datasetFinder, findsNWidgets(2));
//     expect(
//       datasetFinder.evaluate().first.widget.toString(),
//       contains("hidden"),
//     );
//     expect(
//       datasetFinder.evaluate().last.widget.toString(),
//       contains("visible"),
//     );

//     debugPrint("TESTER: Expect the default demo dataset is loaded.");

//     final datasetDisplayFinder = find.byKey(datasetGlimpseKey);

//     expect(datasetDisplayFinder, findsOneWidget);

//     final dataset =
//         datasetDisplayFinder.evaluate().last.widget as SelectableText;

//     expect(dataset.data, contains("Rows: 366\n"));
//     expect(dataset.data, contains("Columns: 24\n"));
//     expect(dataset.data, contains("date            <date>"));
//     expect(dataset.data, contains("rain_tomorrow   <fct>"));

//     debugPrint("TESTER TODO: Debug page confirm expected vars and target");

//     debugPrint("TESTER TODO: Confirm the status bar has been updated.");

//     debugPrint("TESTER: Check R script widget contains the expected code.");

//     final scriptTabFinder = find.text('Script');
//     expect(scriptTabFinder, findsOneWidget);
//     await tester.tap(scriptTabFinder);
//     await tester.pumpAndSettle();
//     await tester.pump(pause);

//     final scriptTextFinder = find.byKey(scriptTextKey);
//     expect(
//       scriptTextFinder.first.toString(),
//       contains('# Rattle Scripts: The main setup.'),
//     );
//     expect(
//       scriptTextFinder.first.toString(),
//       contains('## -- dataset_load_weather.R --'),
//     );
//     expect(
//       scriptTextFinder.first.toString(),
//       contains('## -- dataset_template.R --'),
//     );
//     expect(
//       scriptTextFinder.first.toString(),
//       contains('## -- ds_glimpse.R --'),
//     );

//     debugPrint("TESTER TODO: Tap Export. Check/run export.R.");

//     debugPrint("TESTER TODO: From Dataset tab uncheck Normalise and reload.");

//     // This will test if Date is the first column rather than date. Also
//     // RainTomorrow rather than rain_tomorrow.

//     debugPrint("TESTER: Finished.");
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify that the counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pumpAndSettle();

    // // Verify that the counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
