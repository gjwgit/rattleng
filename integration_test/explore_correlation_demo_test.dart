/// EXPLORE tab: Correlation Demo Dataset Test.
//
// Time-stamp: <Tuesday 2024-08-20 16:43:07 +1000 Graham Williams>
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
/// Authors:  Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/correlation/panel.dart';

import 'package:rattle/main.dart' as app;
import 'helper.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/oepn_demo.dart';
import 'utils/press_button.dart';
import 'utils/verify_page_content.dart';
import 'utils/verify_text.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
// explore_tab_test.dart

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 5);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore Tab:', () {
    testWidgets('Demo Dataset, Explore, Correlation.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // Open the demo dataset.

      await openDemoDataset(tester);

      // Navigate to the Explore tab.

      await navigateToExploreTab(tester);

      // Navigate to the Correlation tab.

      await navigateToTab(tester, 'Correlation', CorrelationPanel);

      // Check the button is there and press it.

      await pressButton(tester, 'Perform Correlation Analysis');

      // Verify the content of the page 1.

      await verifyPageContent(tester, 'Correlation - Numeric Data', '1.00');
      await verifyTextContent(tester, '0.97');
      await verifyTextContent(tester, '0.14');
      await verifyTextContent(tester, '-0.36');

      // Verify the content of the page 2.

      await verifyPageContent(tester, 'Variable Correlation Plot');
    });
  });
}
