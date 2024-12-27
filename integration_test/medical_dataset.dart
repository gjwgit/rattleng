/// Basic DATASET test: LARGE.
//
// Time-stamp: <Monday 2024-09-16 14:52:44 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dataset large:', () {
    testWidgets('Glimpse, Roles.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // Locate the TextField where the file path is input.

      final filePathField = find.byType(TextField);
      expect(filePathField, findsOneWidget);

      // Enter the file path programmatically.

      await tester.enterText(
        filePathField,
        'integration_test/medical.csv',
      );

      // Simulate pressing the Enter key.

      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Optionally pump the widget tree to reflect the changes.
      await tester.pumpAndSettle();

      await tester.pump(interact);

      // Tap the right arrow button to go to ROLES page.

      await gotoNextPage(tester);

      // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
      //
      // How do we ensure the R Code is executed before proceeding in Rattle
      // itself - we need to deal with the async issue in Rattle.

      // // Tap the right arrow button to go to "Dataset Glimpse" page.

      // await tester.tap(rightArrowFinder);
      // await tester.pumpAndSettle();

      // // Find the text containing the number of rows and columns.

      // final glimpseRowFinder = find.textContaining('Rows: 20,000');
      // expect(glimpseRowFinder, findsOneWidget);
      // final glimpseColumnFinder = find.textContaining('Columns: 24');
      // expect(glimpseColumnFinder, findsOneWidget);

      // Tap the right arrow button to go to "ROLES" page.

      await tester.pumpAndSettle();

      // Find the text containing "rec-57600".

      final rolesRecIDFinder = find.textContaining('rec-57600');
      expect(rolesRecIDFinder, findsOneWidget);

      await tester.pump(interact);

      // TODO 20240822 gjw FOR kevin EXTRA DATASET LARGE TESTS
      //
      // Check which variables are INPUT, IGNORE, TARGET
      //
      // Maybe load the provider to make sure the variables are assigned to
      // the expected ROLES.
    });
  });
}
