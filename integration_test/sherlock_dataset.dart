/// Test Wordcloud on the sherlock dataset.
//
// Time-stamp: <Monday 2025-05-12 15:56:30 +1000 Graham Williams>
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/delays.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/tap_button.dart';
import 'utils/tap_checkbox.dart';
import 'utils/verify_selectable_text.dart';

const Duration delay = Duration(seconds: 5);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sherlock Dataset:', () {
    testWidgets('Wordcloud', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(interact);
      await loadDemoDataset(tester, 'Sherlock');
      await navigateToPage(tester, 1, back: 1, title: 'Text Content');
      await verifySelectableText(tester, [
        '{- The Project Gutenberg eBook of The Adventures of Sherlock Holmes,          -}',
      ]);
      await tester.pump(interact);
      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Text');
      await tapButton(tester, 'Text Mine');
      await navigateToPage(tester, 2, back: 2, title: 'Term Frequency');
      await verifySelectableText(tester, [
        'word freq',
        'the   64',
        'and   30',
        'you   25',
        'was   14',
        'her   14',
      ]);
      await tapCheckbox(tester, 'text_remove_stopwords');
      await tapButton(tester, 'Text Mine');
      await verifySelectableText(tester, [
        'word freq',
        'upon    9',
        'little    7',
      ]);
      await tapCheckbox(tester, 'text_stem');
      await tapButton(tester, 'Text Mine');
      await verifySelectableText(tester, [
        'word freq',
        'upon    9',
        'littl    7',
      ]);
      await tapCheckbox(tester, 'text_remove_punctuation');
      await tapButton(tester, 'Text Mine');
      await verifySelectableText(tester, [
        'word freq',
        'upon    9',
        'littl    7',
        'observ    6',
        'one    6',
        'ebook    5',
        'holm    5',
      ]);
    });
  });
}
