/// Support utility for printing debug messages.
//
// Time-stamp: <Friday 2024-12-20 16:37:54 +1100 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

void debugText(String label, [String detail = '', int skip = 15]) {
  // 20240823 gjw Preprocess the label for special circumstances.

  label = label.replaceAll('Role.', '');

  // 20240823 gjw Always upercase the label.

  label = label.toUpperCase();

  // Calculate the number of spaces needed.

  int spacesCount = skip - label.length;

  // Ensure that spacesCount is not negative.

  if (spacesCount < 0) spacesCount = 0;

  // Create a string with the required number of spaces.

  String spaces = ' ' * spacesCount;

  // Combine the first text, spaces, and second text.

  debugPrint('$label$spaces$detail');
}
