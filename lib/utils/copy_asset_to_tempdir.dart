/// Copy asset (e.g., weather.csv) to tempDir.
//
// Time-stamp: <Wednesday 2024-09-18 08:45:34 +1000 Graham Williams>
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

import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import 'package:flutter/services.dart' show rootBundle;

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/utils/debug_text.dart';

Future<String> copyAssetToTempDir({
  required String asset,
}) async {
  // Load the CSV file from assets.

  final ByteData data = await rootBundle.load('assets/$asset');

  // Locate the destination.

  String dest = '$tempDir/${p.basename(asset)}';

  // Create a file in the temp directory.

  final File tempFile = File(dest);

  // Write the CSV file content to the temp file.

  await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

  debugText('  ASSET', dest);

  return dest;
}
