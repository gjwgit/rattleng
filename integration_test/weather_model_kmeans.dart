/// Test kmeans() cluster analysis with demo dataset.
//
// Time-stamp: <Tuesday 2025-04-22 11:09:45 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Load, Navigate, Build.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(interact);
    await loadDemoDataset(tester);
    await navigateToTab(tester, 'Model');
    await navigateToFeature(tester, 'Cluster');
    await tapButton(tester, 'Build Clustering');
    await addDelay(tester, 10);

    // Find the text containing the number of default clusters.

    await navigateToPage(tester, 1, title: 'Cluster Analysis');
    await verifySelectableText(
      tester,
      ["built using 'kmeans' with 10 clusters"],
    );

    await tester.pump(interact);
    await navigateToPage(tester, 2, title: 'Cluster Analysis - Visual');
  });
}
