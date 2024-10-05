/// Scrape the latest json from rattle::meta_data and update the provider.
//
// Time-stamp: <Thursday 2024-08-15 12:29:19 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Space separated. Alphabetic.

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

void updateMetaData(WidgetRef ref) {
  String stdout = ref.read(stdoutProvider);

  String content = rExtract(stdout, '> meta_data(ds)');

  // Only update the meta data if we find meta data in the CONSOLE. Otherwise we
  // get an unexpected character exception.

  if (content.isNotEmpty) {
    Map<String, dynamic> jsonObject = jsonDecode(content);

    // 20240815 gjw Iterate through each key-value pair and add to the
    // provider. Simply assigning the object to the provider raises an exception
    // about updating a provide inside a widget build.

    for (var col in jsonObject.entries) {
      ref.read(metaDataProvider.notifier).state[col.key] = col.value;
    }
  }
}
