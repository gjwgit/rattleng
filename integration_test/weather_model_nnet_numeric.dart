/// Test nnet() with numeric demo dataset.
//
// Time-stamp: <Sunday 2025-03-23 11:12:19 +1100 Graham Williams>
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

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Numeric Demo Model Neural NNet:', () {
    testWidgets('Load, Ignore, Navigate, Build.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Weather');
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Neural');

      // Verify that the markdown content is loaded.

      final markdownContent = find.byKey(const Key('markdown_file'));
      expect(markdownContent, findsOneWidget);

      // Confirm the 'Ignore Categoric' checkbox is ticked.

      // final Finder ignoreCheckbox =
      //     find.byKey(const Key('Neural Ignore Categoric'));
      // await tester.tap(ignoreCheckbox);
      // await tester.pumpAndSettle();

      // Simulate the presence of a neural network being built.

      await tapButton(tester, 'Build Neural Network');
      await tester.pump(hack);
      await navigateToPage(tester, 1);
      await verifySelectableText(
        tester,
        [
          'A 14-10-1 network with',
          'Options were - skip-layer connections  entropy fitting',
        ],
      );
    });
  });
}
