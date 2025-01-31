///  Check if a variable is not missing in the output.
//
// Time-stamp: <Tuesday 2024-09-10 15:56:42 +1000 Graham Williams>
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
/// Authors: Kevin Wang
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/features/dataset/display.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

/// Verifies that a specified variable is not listed as missing in the dataset display.
///
/// This function checks the stdout output from the DatasetDisplay widget to ensure
/// that the given variable is not included in the list of missing variables.
///
/// Parameters:
/// - tester: The WidgetTester used to interact with the widget tree
/// - variable: The name of the variable to check
///
/// Throws a test failure if the variable is found in the missing variables list.
Future<void> checkVariableNotMissing(
  WidgetTester tester,
  String variable,
) async {
  // Get the stdout from the DatasetDisplay widget's state.

  final stdout = tester
      .state<ConsumerState>(
        find.byType(DatasetDisplay),
      )
      .ref
      .read(stdoutProvider);

  // Extract the missing variables information from stdout.

  String missing = rExtract(stdout, '> missing');

  // Use regex to find all variables enclosed in quotes.

  RegExp regExp = RegExp(r'"(.*?)"');
  Iterable<RegExpMatch> matches = regExp.allMatches(missing);

  // Convert regex matches to a list of variable names.

  List<String> variables = matches.map((match) => match.group(1)!).toList();

  // Verify that the specified variable is not in the list of missing variables.

  expect(variables.contains(variable), false);
}
