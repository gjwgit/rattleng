/// Get missing observations
//
// Time-stamp: "Sunday 2025-03-30 09:11:01 +1100 Graham Williams"
//
/// Copyright (C) 2024-2025, Togaware Pty Ltd
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

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

String? getObsMissing(WidgetRef ref) {
  String stdout = ref.read(stdoutProvider);

  String missing = rExtract(stdout, '> nmobs');
  RegExp regExp = RegExp(r'\[\d+\]\s(\d+)');

  // Extracting the matched number
  String? extractedNumber = regExp.firstMatch(missing)?.group(1);

  return extractedNumber;
}
