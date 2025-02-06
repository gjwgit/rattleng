/// Move to the next page.
//
// Time-stamp: <Tuesday 2024-09-24 13:38:08 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rattle/features/evaluate/config.dart';
import 'package:rattle/features/evaluate/display.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/pages.dart';

import 'delays.dart';

Future<void> gotoNextPage(WidgetTester tester) async {
  // Find the right arrow button in the PageIndicator.

  final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
  expect(rightArrowFinder, findsOneWidget);

  // Tap the right arrow button twice to go to the last page for variable role selection.

  await tester.tap(rightArrowFinder);
  await tester.pumpAndSettle();

  // Pause after screen change.

  await tester.pump(interact);
}

// TODO kevin, confirmed this does not work.
// Use ref.read(evaluatePageControllerProvider) cannot navigate to the page.
Future<void> navigateToPage(WidgetTester tester, int page) async {
  // Find the PageViewer widget's PageController
  final pageController = tester
      .state<ConsumerState>(
        find.byType(EvaluateConfig),
      )
      .ref
      .read(evaluatePageControllerProvider);

  await pageController.animateToPage(
    page,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  await tester.pumpAndSettle();

  // Pause after screen change
  await tester.pump(interact);
}

// TODO kevin, confirmed this does not work.
// Use PageViewer widget's PageController cannot navigate to the page.
Future<void> navigateToPageNew(WidgetTester tester, int page) async {
  // Find the Pages widget state
  final pageViewerState =
      tester.state<PageViewerState>(find.byType(PageViewer));

  // Get the PageController from the PageViewer state
  final pageController = pageViewerState.widget.pageController;

  // Animate to the desired page
  await pageController.animateToPage(
    page,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  await tester.pumpAndSettle();

  // Pause after screen change
  await tester.pump(interact);
}
