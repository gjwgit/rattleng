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

import 'utils/delays.dart';
import 'utils/check_popup.dart';
import 'utils/open_demo_dataset.dart';
import 'utils/open_large_dataset.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TRANSFORM CLEANUP IGNORE DEMO:', () {
    testWidgets('cleanup', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(pause);

      await openDatasetByPath(tester, 'assets/data/diabetes.txt');

    });
  });
}
