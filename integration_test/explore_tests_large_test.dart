/// Test the EXPLORE tab TESTS feature on the LARGE dataset.
//
// Time-stamp: <Tuesday 2024-09-03 09:07:59 +1000 Graham Williams>
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

import 'package:rattle/features/tests/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/open_large_dataset.dart';
import 'utils/press_button.dart';
import 'utils/verify_page_content.dart';
import 'utils/verify_text.dart';

import 'helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Explore LARGE TESTS:', () {
    testWidgets('build, page.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openLargeDataset(tester);
      await navigateToExploreTab(tester);
      await navigateToTab(tester, 'Tests', TestsPanel);
      await pressButton(tester, 'Perform Statistical Tests');

      // Verify the content of the page 1.

      await verifyPageContent(
        tester,
        'Pearson Correlation Test',
      );
      await verifyTextContent(
        tester,
        '    Degrees of Freedom: 364',
      );
      await verifyTextContent(
        tester,
        '    Correlation: 0.7525',
      );
      await verifyTextContent(
        tester,
        '    Alternative Two-Sided: < 2.2e-16 ',
      );

      // Verify the content of the page 2.

      await verifyPageContent(tester, '    D | Two Sided: 0.6667');
      await verifyTextContent(
        tester,
        '    Alternative       Two-Sided: < 2.2e-16 ',
      );
      await verifyTextContent(
        tester,
        'W = 9407.5, p-value < 2.2e-16',
      );
      await verifyTextContent(
        tester,
        '[0m[1m3: [0m[1mIn ks.test.default(x = x, y = y, alternative = "greater") :[0m[1m',
      );

      // Verify the content of the page 3.

      await verifyPageContent(tester, 'Wilcoxon Rank Sum Test');
      await verifyTextContent(
        tester,
        'W = 9407.5, p-value < 2.2e-16',
      );

      // Verify the content of the page 4.

      await verifyPageContent(tester, 't-Test Two Sample Location Test');
      await verifyTextContent(
        tester,
        '    x Observations: 366',
      );
      await verifyTextContent(
        tester,
        '    Mean of y: 20.5503',
      );
      await verifyTextContent(
        tester,
        '      Greater: -14.0598, Inf',
      );
    });
  });
}
