/// Utility to strip header comments from an R script file.
///
/// Time-stamp: <Monday 2024-12-02 09:08:14 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
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

/// From the supplied [code] (an R script file contents) strip the initial
/// copyright message from the script, keeping the first line as the script
/// title, and keeping all remaining lines of the script file.

String rStripHeader(String code) {
  // Keep the first line then strip everything down to the first line not
  // starting with a hash.

  List<String> lines = code.split('\n');

  // Find the index of the first line that doesn't start with '#'

  int index = 0;
  while (index < lines.length && lines[index].trim().startsWith('#')) {
    index++;
  }

  // Join the lines. For a single line the sublist processing duplicates the
  // line prefixing it with #. So handle the sinle line edge case specially.

  // TODO 20231102 gjw ACTUALLY I THINK THE PROBLEM IS WHEN THE FIRST LINE DOES
  // NOT START WITH #. SHOULD TEST AND FIX THAT ONE UP.

  String result = '\n${lines.first}';

  if (lines.length > 1) {
    result = "$result\n#${lines.sublist(index).join('\n')}";
  }

  return result;
}
