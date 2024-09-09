/// Test the Transform tab Impute/Rescale/Recode feature on the DEMO dataset.
//
// Time-stamp: <Monday 2024-09-09 19:17:11 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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
/// Authors:  Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/impute/panel.dart';
import 'package:rattle/app.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/get_missing.dart';
import 'package:rattle/providers/stdout.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/press_first_button.dart';
import 'utils/verify_multiple_text.dart';
import 'utils/verify_page_content.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Transform DEMO:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      // Create a ProviderContainer to access the ref.
      final container = ProviderContainer();

      // Initialize the app.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: RattleApp(),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(pause);

      // Open the demo dataset and navigate to the Transform tab.
      await openDemoDataset(tester);
      await navigateToTab(tester, 'Transform');

      // Navigate to the Impute page.
      await navigateToFeature(tester, 'Impute', ImputePanel);

      // Use the container to read the provider value
      final stdout = container.read(stdoutProvider);

      String missing = rExtract(stdout, '> missing');

      // Regular expression to match strings between quotes

      RegExp regExp = RegExp(r'"(.*?)"');

      // Find all matches

      Iterable<RegExpMatch> matches = regExp.allMatches(missing);

      // Extract the matched strings

      List<String> variables = matches.map((match) => match.group(1)!).toList();

      print(variables);

      print("=====================================");

      // Step 1: Run get_missing to check sunshine is there.
      List<String> result = getMissing(
          container.read as WidgetRef); // Use container.read to pass the ref
      print(result.toString());

      // Simulate pressing the first button to impute missing values.
      await pressFirstButton(tester, 'Impute Missing Values');

      // Verify the content of the page.
      await verifyPageContent(
        tester,
        'Dataset Summary',
        'IZR_sunshine',
      );

      // Verify the IZR_sunshine parameter values.
      await verifyMultipleTextContent(
        tester,
        [
          'Min.   : 0.000',
          '1st Qu.: 5.900',
          'Median : 8.600',
          'Mean   : 7.845',
          '3rd Qu.:10.500',
          'Max.   :13.600',
        ],
      );

      // Dispose of the ProviderContainer when done to prevent memory leaks.
      container.dispose();
    });
  });
}
