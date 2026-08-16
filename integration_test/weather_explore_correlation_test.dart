/// Test WEATHER dataset EXPLORE tab CORRELATION feature.
//
// Time-stamp: <Tuesday 2026-01-06 15:21:48 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors:  Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather Explore Correlation:', () {
    testWidgets('Check calculated correlations.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Explore');
      await navigateToFeature(tester, 'Correlation');
      await tapButton(tester, 'Perform Correlation Analysis');
      await tester.pump(hack);
      await navigateToPage(
        tester,
        4,
        back: 1,
        title: 'Correlation - Numeric Data',
      );
      await verifyPage('Correlation - Numeric Data', '1.00');
      await verifySelectableText(tester, [
        'min_temp          1.00     0.90     0.69     0.64     0.32            0.28           0.27     0.27    0.16',
        'temp_9am          0.90     1.00     0.84     0.80     0.41            0.23           0.14     0.20    0.10',
        'max_temp          0.69     0.84     1.00     0.99     0.27           -0.08           0.02     0.06   -0.07',
      ]);
    });
  });
}
