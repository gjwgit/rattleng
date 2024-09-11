/// Obtain list of variables that have a unique value.
//
// Time-stamp: <Sunday 2024-09-08 12:18:44 +1000 Graham Williams>
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
/// Authors:

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

List<String> getUniqueColumns(WidgetRef ref) {
  String stdout = ref.watch(stdoutProvider);

  String uniqueColumns = rExtract(stdout, 'unique_columns(ds)');

  uniqueColumns = uniqueColumns.replaceAll(RegExp(r'^ *\[[^\]]\] '), '');

  // Extract the ids from the output of unique_columns().

  RegExp regExp = RegExp(r'"(.*?)"');
  Iterable<Match> matches = regExp.allMatches(uniqueColumns);
  List<String> ids = matches.map((match) => match.group(1)!).toList();

  return ids;
}
