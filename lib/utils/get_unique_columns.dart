/// Obtain list of variables that have a unique value.
//
// Time-stamp: "Sunday 2026-01-18 11:58:51 +1100 Graham Williams"
//
/// Copyright (C) 2024-2026, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors:

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

List<String> getUniqueColumns(WidgetRef ref) {
  // 20260118 gjw I considered replacing the console scanning implementation
  // using `unique_colums()` (whose definition we will now remove from the R
  // code setup) with accessing the data from the meta data provider.  But I do
  // not currently have the number of rows captured in a provider. Once that is
  // captured we can use the meta data to determine the columns with unique
  // values. This may be quicker than scanning the console for the output of
  // `unique_columns()`

  String stdout = ref.watch(stdoutProvider);

  String uniqueColumns = rExtract(stdout, 'unique_columns(ds)');

  uniqueColumns = uniqueColumns.replaceAll(RegExp(r'^ *\[[^\]]\] '), '');

  // Extract the ids from the output of unique_columns().

  RegExp regExp = RegExp(r'"(.*?)"');
  Iterable<Match> matches = regExp.allMatches(uniqueColumns);
  List<String> ids = matches.map((match) => match.group(1)!).toList();

  // Map metaData = ref.read(metaDataProvider);

  // List<String> ids = [];

  // final nRows = 365;

  // for (var entry in metaData.entries) {
  //   // Ensure the value is a Map and check the 'unique' key.

  //   if (entry.value is Map<String, dynamic>) {
  //     var uniqueList = (entry.value as Map<String, dynamic>)['unique'];

  //     // Check if 'unique' is a List and if the first element is the same as the
  //     // number of rows in the dataset.

  //     if (uniqueList is List &&
  //         uniqueList.isNotEmpty &&
  //         uniqueList[0] == nRows) {
  //       ids.add(entry.key);
  //     }
  //   }
  // }

  return ids;
}
