/// Test Wordcloud on the sherlock dataset.
//
// Time-stamp: <Tuesday 2024-10-15 19:22:21 +1100 Graham Williams>
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
/// Authors: Yixiang Yin, Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/wordcloud/panel.dart';
import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/load_dataset_by_path.dart';

const Duration delay = Duration(seconds: 5);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sherlock Dataset:', () {
    testWidgets('Wordcloud', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);

      await loadDatasetByPath(tester, 'integration_test/sherlock.txt');

      await gotoNextPage(tester);

      // Check first line of the file

      final textFinder = find.textContaining(
        '{- The Project Gutenberg eBook of The Adventures of Sherlock Holmes,          -}',
      );
      expect(textFinder, findsOneWidget);

      await tester.pump(interact);

      // If this passes, it means we are in the same page as before.

      final textFinder2 = find.textContaining(
        '{- The Project Gutenberg eBook of The Adventures of Sherlock Holmes,          -}',
      );
      expect(textFinder2, findsOneWidget);

      // Navigate to the Model tab

      final modelTabFinder = find.text('Model');
      expect(modelTabFinder, findsOneWidget);
      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // Navigate to the Tree feature.

      await navigateToFeature(tester, 'Word Cloud', WordCloudPanel);

      // Find and tap the 'Display Word Cloud' button

      final displayWordCloudButtonFinder = find.text('Display Word Cloud');
      expect(displayWordCloudButtonFinder, findsOneWidget);
      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Go to the third page

      await gotoNextPage(tester);

      // Confirm these entries are in the frequency table

      final freqFinder = find.textContaining('upon    9');
      expect(freqFinder, findsOneWidget);

      final freqFinder2 = find.textContaining('little    7');
      expect(freqFinder2, findsOneWidget);

      // Confirm these entries are not in the frequency table

      final freqFinder5 = find.textContaining('littl    7');
      expect(freqFinder5, findsNothing);

      // Find the second checkbox (which should be the 'Stem' checkbox)

      final stemCheckboxFinder = find.byType(Checkbox).at(1);
      expect(stemCheckboxFinder, findsOneWidget);

      // Tap the checkbox to uncheck it

      await tester.tap(stemCheckboxFinder);
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Go to the third page

      await gotoNextPage(tester);

      // Confirm this entry is not in the frequency table

      final freqFinder3 = find.textContaining('littl   7');
      expect(freqFinder3, findsNothing);
      await tester.pumpAndSettle();
      await tester.pump(interact);

      // Confirm this entry is in the frequency table

      final freqFinder4 = find.textContaining('little    7');
      expect(freqFinder4, findsOneWidget);

      // Confirm the word cloud contains the text "again?"

//      final againTextFinder = find.textContaining('holmes');
//      expect(againTextFinder, findsOneWidget);

      // Find the third checkbox (remove punctuation)

      final thirdCheckboxFinder = find.byType(Checkbox).at(2);
      expect(thirdCheckboxFinder, findsOneWidget);

      // Tap the third checkbox to check it

      await tester.tap(thirdCheckboxFinder);
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button again after checking the checkbox

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Confirm that "again?" is no longer present in the word cloud

//      expect(againTextFinder, findsNothing);

      // Find the fourth checkbox (for remove stopwords)

      final fourthCheckboxFinder = find.byType(Checkbox).at(3);
      expect(fourthCheckboxFinder, findsOneWidget);

      // Tap the fourth checkbox to check it

      await tester.tap(fourthCheckboxFinder);
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button again after checking the checkbox

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Confirm this entry is in the frequency table

//      final theTextFinder = find.textContaining('the   64');
//      expect(theTextFinder, findsOneWidget);

      // Confirm that 'the   64' is no longer present in the word cloud after checkbox is checked

//      expect(theTextFinder, findsNothing);

      // Find the TextField using its label 'Max Words'

      final textFieldFinder = find.widgetWithText(TextField, 'Max Words');
      expect(textFieldFinder, findsOneWidget);

      // Enter '1' in the TextField

      await tester.enterText(textFieldFinder, '1');
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Verify that this is not present in the word cloud

      expect(freqFinder4, findsNothing);

      // Verify that "upon   9" is present in the word cloud

//      final uponTextFinder = find.textContaining('upon    9');
//      expect(uponTextFinder, findsOneWidget);

      // Clear the TextField by entering an empty string

      final textFieldWidget = tester.widget<TextField>(textFieldFinder);
      textFieldWidget.controller?.clear();
      await tester.pumpAndSettle();
      expect(textFieldWidget.controller?.text, isEmpty);

      // Find the TextField using its label 'Min Freq'

      final minFreqFinder = find.widgetWithText(TextField, 'Min Freq');
      expect(minFreqFinder, findsOneWidget);

      // Enter '2' for Min Freq

      await tester.enterText(minFreqFinder, '2');
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(delay);

      // Confirm that 1 is not in the frequency table

      final oneFinder = find.text('1');
      expect(oneFinder, findsNothing);
    });
  });
}
