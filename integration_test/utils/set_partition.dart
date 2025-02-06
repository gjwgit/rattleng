/// Set the dataset partition option  on/off.
///
// Time-stamp: <Thursday 2025-02-06 08:22:07 +1100 Graham Williams>
///
/// Copyright (C) 2025, Togaware Pty Ltd
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

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/dataset/toggles.dart';
import 'package:rattle/providers/partition.dart';

Future<void> setPartition(WidgetTester tester, bool on) async {
  final iconFinder = find.byIcon(Icons.horizontal_split);
  expect(iconFinder, findsOneWidget);

  // Get initial partition state.

  final partitionState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(partitionProvider);

  // 20250206 gjw If partition is enabled and we want to turn it off, or the
  // partition is disabled and we want to turn it on, then tap the parition icon
  // to.

  if ((partitionState && !on) || (!partitionState && on)) {
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();
  }

  // Verify partition is now enabled.

  final updatedPartitionState = tester
      .state<ConsumerState>(
        find.byType(DatasetToggles),
      )
      .ref
      .read(partitionProvider);
  expect(updatedPartitionState, on);

  await tester.pumpAndSettle();
}
