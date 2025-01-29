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

Future<void> checkVariableNotMissing(
  WidgetTester tester,
  String variable,
) async {
  final stdout = tester
      .state<ConsumerState>(
        find.byType(DatasetDisplay),
      )
      .ref
      .read(stdoutProvider);
  String missing = rExtract(stdout, '> missing');

  RegExp regExp = RegExp(r'"(.*?)"');
  Iterable<RegExpMatch> matches = regExp.allMatches(missing);
  List<String> variables = matches.map((match) => match.group(1)!).toList();

  expect(variables.contains(variable), false);
}
