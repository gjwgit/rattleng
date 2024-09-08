/// Test the DATASET tab GLIMPSE and ROLE features with the DEMO dataset.
//
// Time-stamp: <Tuesday 2024-09-03 09:09:38 +1000 Graham Williams>
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
/// Authors: Graham Williams, Kevin Wang

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';

import 'utils/delays.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Dataset:', () {
    testWidgets('Glimpse, Roles.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final datasetButtonFinder = find.byType(DatasetButton);
      expect(datasetButtonFinder, findsOneWidget);
      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      expect(datasetButton, findsOneWidget);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);
      final demoButton = find.text('Demo');
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      final dsPathTextFinder = find.byKey(datasetPathKey);
      expect(dsPathTextFinder, findsOneWidget);
      final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
      String filename = dsPathText.controller?.text ?? '';
      expect(filename, 'rattle::weather');

      // Find the right arrow button in the PageIndicator.

      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to "Dataset Glimpse" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Find the text containing "366".

      final glimpseRowFinder = find.textContaining('366');
      expect(glimpseRowFinder, findsOneWidget);

      // Find the text containing "2007-11-01".

      final glimpseDateFinder = find.textContaining('2007-11-01');
      expect(glimpseDateFinder, findsOneWidget);

      // Tap the right arrow button to go to "ROLES" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Find the text containing "8.0".

      final rolesTempFinder = find.textContaining('8.0');
      expect(rolesTempFinder, findsOneWidget);

      //TODO  kevin
    });
  });
}
