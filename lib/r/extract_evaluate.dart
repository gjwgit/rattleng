/// Utility to extract the EXECUTE from R log.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-09-27 05:39:57 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/timestamp.dart';

String _basicTemplate(
  String log,
  String modelType,
  WidgetRef ref,
) {
  String hd;
  String md;

  if (modelType == 'Tree') {
    hd = 'Error matrix for the Decision Tree model (counts)';
    md = 'Error matrix for the Decision Tree model (proportions)';
  } else {
    // Handle other types or return an empty result.

    return '';
  }

  // Now extract the output from particular commands.

  String sz = '', cm = '';

  if (modelType == 'Tree') {
    sz = rExtract(
      log,
      'print(cem)',
    );
    cm = rExtract(
      log,
      'print(per)',
    );
  }

  // Obtain the current timestamp.

  final String ts = timestamp();

  // Build the result.

  String result = '';

  if (sz != '') {
    result = '$hd\n\n'
        '\n$sz\n\n'
        '$md\n\n'
        '\n$cm\n\n'
        'Rattle timestamp: $ts';
  }

  return result;
}

String rExtractEvaluate(
  String log,
  String modelType,
  WidgetRef ref,
) {
  // Extract from the R log those lines of output from the evaluate.

  String extract = _basicTemplate(
    log,
    modelType,
    ref,
  );

  return extract;
}
