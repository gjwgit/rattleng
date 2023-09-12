/// A basic widget test for the Rattle app.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-09-10 18:20:10 +1000 Graham Williams>
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
//
// To perform an interaction with a widget in the test we use the WidgetTester
// utility that Flutter provides. For example, we can send tap and scroll
// gestures. We can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// A tester.pump(Duration) schedules a frame and triggers a rebuild of the
// widget. If a Duration is specified, it advances the clock by that amount and
// schedules a frame. It does not schedule multiple frames even if the duration
// is longer than a single frame. This method provides fine-grained control over
// the build lifecycle, which is particularly useful while testing. To kick off
// the animation, you need to call pump() once (with no duration specified) to
// start the ticker. Without it, the animation does not start.
//
// A tester.pumpAndSettle() repeatedly calls pump() with the given duration
// until there are no longer any frames scheduled. This, essentially, waits for
// all animations to complete. This method provides fine-grained control over
// the build lifecycle, which is particularly useful while testing.

// References:
//
// https://docs.flutter.dev/cookbook/testing/widget/introduction

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/constants/app.dart' show appTitle;
import 'package:rattle/rattle_app.dart';

// 20230828 gjw R PROCESS NOT YET WORKING
// import 'package:rattle/helpers/r.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.

  testWidgets('Rattle unit test.', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it. Here we build the
    // app and trigger a frame.

    await tester.pumpWidget(const RattleApp());

    // Verify some widgets from the home page.

    final title = find.text(appTitle);
    expect(title, findsOneWidget);

    // There should be a single filePicker - Filename:

    final filePicker = find.byKey(const Key("file_picker_ds"));
    expect(filePicker, findsOneWidget);

    // There should be a single run button.

    final runButton = find.byKey(const Key("run_button"));
    expect(runButton, findsOneWidget);

    // Tap the Run button.

    // 20230828 gjw R PROCESS NOT YET WORKING.

    // rStart();
    // await tester.tap(runButton);
  });
}
