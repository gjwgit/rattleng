// / Testing: Basic app startup test.
// /
// / Copyright (C) 2023, Software Innovation Institute, ANU.
// /
// / License: http://www.apache.org/licenses/LICENSE-2.0
// /
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// /
// / Authors: Graham Williams

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

  testWidgets('Home page loads okay.', (WidgetTester tester) async {
    debugPrint('TESTER: Start up the app');

    app.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page.

    await tester.pump(pause);

    final datasetButtonFinder = find.byType(DatasetButton);
    expect(datasetButtonFinder, findsOneWidget);
    await tester.pump(pause);

    debugPrint('TESTER: Tap the Dataset button.');

    final datasetButton = find.byType(DatasetButton);
    expect(datasetButton, findsOneWidget);
    await tester.pump(pause);
    await tester.tap(datasetButton);
    await tester.pumpAndSettle();

    await tester.pump(delay);

    debugPrint('TESTER: Tap the Filename button.');

    final datasetPopup = find.byType(DatasetPopup);
    expect(datasetPopup, findsOneWidget);
    final filenameButton = find.text('Filename');
    expect(filenameButton, findsOneWidget);
    await tester.tap(filenameButton);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));

    debugPrint('TESTER: Expect the default demo dataset is identified.');

    ////////////////////////////////////////////////////////////////////////
    // DATASET Large DATASET tab (GLIMPSE and ROLES pages) (By Kevin)
    ////////////////////////////////////////////////////////////////////////

    // Find the right arrow button in the PageIndicator.

    final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
    expect(rightArrowFinder, findsOneWidget);

    // Tap the right arrow button to go to "Dataset Glimpse" page.

    await tester.tap(rightArrowFinder);
    await tester.pumpAndSettle();

    // Find the text containing "20,000".

    final glimpseRowFinder = find.textContaining('20,000');
    expect(glimpseRowFinder, findsOneWidget);

    // Find the text containing "24".

    final glimpseColumnFinder = find.textContaining('24');
    expect(glimpseColumnFinder, findsOneWidget);

    // Tap the right arrow button to go to "ROLES" page.

    await tester.tap(rightArrowFinder);
    await tester.pumpAndSettle();

    // Find the text containing "rec-57600".

    final rolesRecIDFinder = find.textContaining('rec-57600');
    expect(rolesRecIDFinder, findsOneWidget);

    debugPrint('TESTER: Finished.');
  });
}
