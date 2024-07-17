/// Utility to extract the latest print(model_rpart) from R.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-07-17 15:08:18 +1000 Graham Williams>
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

// TODO 20230916 gjw ADD EXTRA PARAMETER AS THE PATTERN TO EXTRACT SINCE ALL
// THREE SO FAR ARE BASICALLY THE SAME

String rExtract(String txt, String pat) {
  // Split the string into lines.

  List<String> lines = txt.split('\n');

  List<String> result = [];

  // Initialize with a value that indicates no start index found.

  int startIndex = -1;

  for (int i = lines.length - 1; i >= 0; i--) {
    if (lines[i].contains(pat)) {
      startIndex = i;
      break;
    }
  }

  debugPrint('$startIndex');

  if (startIndex != -1) {
    for (int i = startIndex + 1; i < lines.length; i++) {
      if (lines[i].startsWith('>')) {
        // Found the next line starting with '>'. Stop adding lines to the
        // result.

        break;
      }
      debugPrint(lines[i]);
      result.add(lines[i]);
    }
  }

  // Join the lines.

  return result.join('\n');
}
