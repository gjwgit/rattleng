/// Count the number of lines (\n) in a String.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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

// Count the number of lines in [txt].

int countLines(String txt) {
  // Initialize a counter variable to store the number of lines.

  int count = 0;

  // Loop through each character in the string.

  for (int i = 0; i < txt.length; i++) {
    // If the character is a newline character, increment the counter.

    if (txt[i] == '\n') {
      count++;
    }
  }

  // Return the counter value.

  return count;
}
