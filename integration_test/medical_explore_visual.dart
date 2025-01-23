/// Test EXPLORE tab VISUAL feature LARGE dataset.
//
// Time-stamp: <Friday 2025-01-24 06:44:01 +1100 Graham Williams>
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
/// Authors: Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/visual/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Visual feature.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(hack);

    await loadDatasetByPath(tester, 'integration_test/medical.csv');
    await navigateToTab(tester, 'Explore');
    await navigateToFeature(tester, 'Visual', VisualPanel);
    await tapButton(tester, 'Generate Plots');
    await tester.pump(delay);
    await gotoNextPage(tester);
    await verifyPage('Box Plot Notch');
    await gotoNextPage(tester);
    await verifyPage('Density Plot of Values');
    await gotoNextPage(tester);
    await verifyPage('Cumulative Plot');
    await gotoNextPage(tester);
    await verifyPage('Benford Plot');
  });
}
