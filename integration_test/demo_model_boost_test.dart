/// Build BOOST model.
//
// Time-stamp: <Tuesday 2024-08-20 20:05:55 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/boost/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/press_button.dart';
import 'utils/verify_next_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Boost Demo Test:', () {
    testWidgets('XGBoost.', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDemoDataset(tester);

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost', BoostPanel);

      await pressButton(tester, 'Build Boosted Trees');
      await tester.pump(longHack);

      await gotoNextPage(tester);
      await tester.pump(hack);

      // Verify the content of the page.

      await verifyPage(
        'XGBoost - Summary',
        'Feature         Gain        Cover   Frequency   Importance',
      );

      await gotoNextPage(tester);
      await tester.pump(hack);

      final imagePageTitleFinder = find.text('Variable Importance');
      expect(imagePageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.

      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });

    testWidgets('AdaBoost.', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openDemoDataset(tester);

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost', BoostPanel);

      // Find the ChoiceChipTip widget for the algorithm type.

      final adaChip = find.text(
        'Adaptive',
      );

      // Tap the adaptive chip to switch algorithm.

      await tester.tap(adaChip);

      await tester.pumpAndSettle();

      await pressButton(tester, 'Build Boosted Trees');
      await tester.pump(longHack);

      await gotoNextPage(tester);
      await tester.pump(hack);

      // Verify the content of the page.

      await verifyPage(
        'AdaBoost - Summary',
        'Final Confusion Matrix for Data:',
      );

      await gotoNextPage(tester);
      await tester.pump(hack);

      final imagePageTitleFinder = find.text('Variable Importance');
      expect(imagePageTitleFinder, findsOneWidget);

      final imageFinder = find.byType(ImagePage);

      // Assert that the image is present.

      expect(imageFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
