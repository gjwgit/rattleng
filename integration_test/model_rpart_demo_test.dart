/// Testing: Test the dataset demo functionality.
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

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/main.dart' as rattle;
import 'package:rattle/dataset/button.dart';
import 'package:rattle/dataset/popup.dart';

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

void main() {
  group('Basic App Test:', () {
    testWidgets('Home page loads okay.', (WidgetTester tester) async {
      print("TESTER: Start up the app");

      rattle.main();

      // Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      print("TESTER: Find the DatasetButton, tap, then tap Demo.");

      var datasetButton = find.byType(DatasetButton);
      expect(datasetButton, findsOneWidget);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();
      await tester.pump(pause);
      var datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);
      var demoButton = find.text("Demo");
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // // Find the Run button and start pressing it.

      // var runButton = find.byKey(const Key("run_button"));
      // expect(runButton, findsOneWidget);
      // await tester.pump(pause);
      // await tester.tap(runButton);
      // await tester.pumpAndSettle();
      // await tester.pump(pause);

      // Tap again to have some R scripts run to set up the data template.

      // await tester.tap(runButton);
      // await tester.pumpAndSettle();

      // TODO TEST THIS SUCCEEDED

      // TODO TAP TO THE MODEL TAB

      // TODO TEST THIS SUCCEEDED

      // TODO TAP THE RUN BUTTON AGAIN

      // TODO TEST THIS SUCCEEDED

      // GO TO LOG TAB

      // TODO TEST THIS SUCCEEDED

      print("TESTER: Finished.");
    });
  });
}
