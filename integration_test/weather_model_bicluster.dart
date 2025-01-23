/// Test bicluster() cluster analysis with demo dataset.
//
// Time-stamp: <Sunday 2024-10-13 13:27:51 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/cluster/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/tabs/model.dart';

import 'utils/delays.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Model BiCluster:', () {
    testWidgets('Load, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.pump(interact);

      await loadDemoDataset(tester);

      await navigateToPage(
        tester,
        Icons.model_training,
        ModelTabs,
      );

      // Navigate to the Cluster feature.

      await navigateToFeature(tester, 'Cluster', ClusterPanel);

      await tester.pump(interact);

      // Find the ChoiceChipTip widget for BiCluster type.

      final biclusterChip = find.text(
        'BiCluster',
      );

      // Tap the BiCluster chip to switch type.

      await tester.tap(biclusterChip);

      await tester.pumpAndSettle();

      await tapButton(tester, 'Build Clustering');

      await tester.pump(delay);

      await tapButton(tester, 'Build Clustering');

      await tester.pump(interact);

      // Find the text containing the number of default clusters.

      final dataFinder = find.textContaining('Cluster Means:');
      expect(dataFinder, findsOneWidget);

      await tester.pump(interact);
    });
  });
}
