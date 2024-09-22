/// Test Wordcloud on the sherlock dataset.
//
// Time-stamp: <Wednesday 2024-09-04 12:08:08 +1000 Graham Williams>
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
/// Authors: Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/check_popup.dart';
import 'utils/next_page.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/open_large_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sherlock Dataset:', () {
    testWidgets('Wordcloud', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDatasetByPath(tester, 'integration_test/sherlock.txt');

      await goToNextPage(tester);

      // first line of the file
      final textFinder = find.textContaining(
          '{- The Project Gutenberg eBook of The Adventures of Sherlock Holmes,          -}');
      expect(textFinder, findsOneWidget);

      await goToNextPage(tester);

      // if this passes, it means we are in the same page as before.
      final textFinder2 = find.textContaining(
          '{- The Project Gutenberg eBook of The Adventures of Sherlock Holmes,          -}');
      expect(textFinder2, findsOneWidget);

      // Navigate to the Model tab
      final modelTabFinder = find.text('Model');
      expect(modelTabFinder, findsOneWidget);
      await tester.tap(modelTabFinder);
      await tester.pumpAndSettle();

      // // Navigate to the Word Cloud subtab
      // final wordCloudSubTabFinder = find.text(
      //     'Word Cloud',);
      // expect(wordCloudSubTabFinder, findsOneWidget);
      // await tester.tap(wordCloudSubTabFinder);
      // await tester.pumpAndSettle();

      // Find and tap the 'Display Word Cloud' button

      final displayWordCloudButtonFinder = find.text('Display Word Cloud');
      expect(displayWordCloudButtonFinder, findsOneWidget);
      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // Go to the third page

      await goToNextPage(tester);
      await goToNextPage(tester);

      // Confirm the first entry in the frequency table
      // The empty space are tabs
      final freqFinder = find.textContaining('the   64');
      expect(freqFinder, findsOneWidget);
      // Perform scrolling in case the text is not visible initially
      // await tester.drag(
      //     find.byType(TextPage), const Offset(0, -300),); // Scroll down
      // await tester.pumpAndSettle();
      final freqFinder2 = find.textContaining('little    7');
      expect(freqFinder2, findsOneWidget);

      final freqFinder5 = find.textContaining('littl   7');
      expect(freqFinder5, findsNothing);

      // Find the checkbox with the label 'Stem'

// Find the second checkbox (which should be the 'Stem' checkbox)
      final stemCheckboxFinder = find.byType(Checkbox).at(1);
      expect(stemCheckboxFinder, findsOneWidget);

      // final stemLabelFinder = find.text('Stem');
      // final stemCheckboxFinder = find.descendant(
      //   of: stemLabelFinder,
      //   matching: find.byType(Checkbox),
      // );
      // expect(stemCheckboxFinder, findsOneWidget);

      // Tap the checkbox to check it

      await tester.tap(stemCheckboxFinder);
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final freqFinder3 = find.textContaining('little   7');
      expect(freqFinder3, findsNothing);
      // await tester.drag(
      //   find.byType(TextPage),
      //   const Offset(0, -300),
      // ); // Scroll down
      await tester.pumpAndSettle();
      await tester.pump(pause);
      final freqFinder4 = find.textContaining('littl    7');
      expect(freqFinder4, findsOneWidget);

      // Confirm the word cloud contains the text "again?"
      final againTextFinder = find.textContaining('again?');
      expect(againTextFinder, findsOneWidget);

      // Find the third checkbox (assuming it controls a feature like stemming)
      final thirdCheckboxFinder =
          find.byType(Checkbox).at(2); // Index 2 for third checkbox
      expect(thirdCheckboxFinder, findsOneWidget);

      // Tap the third checkbox to check it
      await tester.tap(thirdCheckboxFinder);
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button again after checking the checkbox
      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // Confirm that "again?" is no longer present in the word cloud after checkbox is checked
      expect(againTextFinder, findsNothing);

      // Confirm the word cloud contains the text "the"
      final theTextFinder = find.textContaining('the   64');
      expect(theTextFinder, findsOneWidget);

      // Find the fourth checkbox (index 3 for fourth checkbox)
      final fourthCheckboxFinder = find.byType(Checkbox).at(3);
      expect(fourthCheckboxFinder, findsOneWidget);
      // Tap the fourth checkbox to check it
      await tester.tap(fourthCheckboxFinder);
      await tester.pumpAndSettle();

      // Tap the 'Display Word Cloud' button again after checking the checkbox
      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      // Confirm that "the" is no longer present in the word cloud after checkbox is checked
      expect(theTextFinder, findsNothing);

      // Find the TextField using its label 'Max Words'
      final textFieldFinder = find.widgetWithText(TextField, 'Max Words');
      expect(textFieldFinder, findsOneWidget);

      // Enter '1' in the TextField
      await tester.enterText(textFieldFinder, '1');
      await tester.pumpAndSettle();

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();

      // Verify that "the   64" is not present in the word cloud
      expect(theTextFinder, findsNothing);

      // Verify that "upon   9" is present in the word cloud
      final uponTextFinder = find.textContaining('upon    9');
      expect(uponTextFinder, findsOneWidget);

      // Clear the TextField by entering an empty string
      final textFieldWidget = tester.widget<TextField>(textFieldFinder);
      textFieldWidget.controller
          ?.clear(); // Explicitly clear the TextEditingController
      await tester.pumpAndSettle();
      expect(textFieldWidget.controller?.text, isEmpty);
      
      // await tester.enterText(textFieldFinder, '');
      // await tester.pumpAndSettle();
      // await tester.tap(displayWordCloudButtonFinder);
      // await tester.pumpAndSettle();

      // Find the TextField using its label 'Min Freq'
      final minFreqFinder = find.widgetWithText(TextField, 'Min Freq');
      expect(minFreqFinder, findsOneWidget);

      // Enter '1' in the TextField
      await tester.enterText(minFreqFinder, '2');
      await tester.pumpAndSettle();

      await tester.tap(displayWordCloudButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final oneFinder = find.text('1');
      expect(oneFinder, findsNothing);
    });
  });
}
