/// Map global template patterns to their values.
///
// Time-stamp: "Friday 2025-09-12 13:56:16 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/io.dart' show Platform;

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/dataset.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/utils/timestamp.dart';

/// Map global template patterns in [code] to their current values.
///
/// Replace Global template patterns with their values. These are not specific
/// to any particular feature.

Future<String> mapGlobal(WidgetRef ref, String code) async {
  String path = ref.read(pathProvider);

  code = code.replaceAll('<TIMESTAMP>', 'Rattle ${timestamp()}');

  PackageInfo info = await PackageInfo.fromPlatform();

  code = code.replaceAll('<VERSION>', info.version);

  // 20240825 lutra Fix the path to the dataset to ensure that the Windows path
  // has been correctly converted to a Unix path for R.

  if (Platform.isWindows) {
    path = path.replaceAll(r'\', '/');
  }

  code = code.replaceAll('<FILENAME>', path);

  code = code.replaceAll('<TEMPDIR>', tempDir);

  String package = ref.read(packageProvider);
  code = code.replaceAll('<PACKAGE>', package);

  String dataset = ref.read(datasetProvider);
  code = code.replaceAll('<DATASET>', dataset);

  return (code);
}
