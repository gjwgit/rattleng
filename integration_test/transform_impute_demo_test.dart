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
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/source.dart';

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

      // Step 1: Run get_missing to check sunshine is there.

      // Use the container to read the provider value.

      final stdout = container.read(stdoutProvider);

      String missing = rExtract(stdout, '> missing');

      // Regular expression to match strings between quotes

      RegExp regExp = RegExp(r'"(.*?)"');

      // Find all matches

      Iterable<RegExpMatch> matches = regExp.allMatches(missing);

      // Extract the matched strings

      List<String> variables = matches.map((match) => match.group(1)!).toList();

      // Check if the variable sunshine is in the list of missing variables.

      // Convert all elements in variables to lowercase and check if any match 'sunshine'.

      expect(
        variables.any((element) => element.toLowerCase() == 'sunshine'),
        true,
      );

      // Step 2:  Simulate pressing the first button to impute missing values.

      await pressFirstButton(tester, 'Impute Missing Values');

      await tester.pump(hack);

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

      // Step 2.5 Tips and Tricks:  Navigate to the Dataset page to fix the update bug.

      await navigateToTab(tester, 'Dataset');

      await tester.pump(pause);

      // Step 3: Run get_vars to check if IZR_sunshine is  there.

      // Use the container to read the provider value.

      Map<String, Role> roles = container.read(rolesProvider);

      // Extract the input variable from the rolesProvider.

      List<String> vars = [];
      roles.forEach((key, value) {
        if (value == Role.input || value == Role.risk || value == Role.target) {
          vars.add(key);
        }
      });

      // Check if the variable sunshine is not in the list of missing variables.

      //TODO kevin 2024-09-10 16:00:00 +1000 to fix this later
      expect(vars.contains('IZR_sunshine'), true);

      //Step 4: check if IZR_sunshine is  not there.

      // Use the container to read the provider value.

      final stdout2 = container.read(stdoutProvider);

      String missing2 = rExtract(stdout2, '> missing');

      // Find all matches

      Iterable<RegExpMatch> matches2 = regExp.allMatches(missing2);

      // Extract the matched strings

      List<String> variables2 =
          matches2.map((match) => match.group(1)!).toList();

      // Check if the variable IZR_sunshine is not in the list of missing variables.

      expect(variables2.contains('IZR_sunshine'), false);

      // Dispose of the ProviderContainer when done to prevent memory leaks.

      container.dispose();
    });
  });
}
