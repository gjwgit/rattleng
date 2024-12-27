/// Build BOOST model.
//
// Time-stamp: <Sunday 2024-10-13 12:33:29 +1100 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/boost/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/open_weather_dataset.dart';
import 'utils/press_button.dart';
import 'utils/verify_next_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Model Boost XGBoost', () {
    testWidgets('Load, Navigate, Build.', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await tester.pump(interact);

      await openWeatherDataset(tester);

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost', BoostPanel);

      await pressButton(tester, 'Build Boosted Trees');
      await tester.pump(longHack);

      await pressButton(tester, 'Build Boosted Trees');

      // Verify the content of the page.

      await verifyPage(
        'XGBoost - Summary',
        'Feature         Gain        Cover    Frequency   Importance',
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
