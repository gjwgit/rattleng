/// Add an empty line before header lines in the given string.
//
// Time-stamp: <Friday 2024-07-19 09:11:23 +1000 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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

/// We assume a header line is non-blank and does not contain a colon (":").
/// If a header line is found and the preceding line is not blank, an empty line is inserted.

String addBlankLinesBeforeHeaders(String input) {
  final lines = input.split('\n');
  final List<String> outputLines = [];

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();
    // Consider a line a header if it's non-empty and does NOT contain a colon.

    final isHeader = trimmed.isNotEmpty && !trimmed.contains(':');

    // For header lines (except the very first line),
    // if the previous line in the output is not blank, add an empty line.

    if (isHeader &&
        outputLines.isNotEmpty &&
        outputLines.last.trim().isNotEmpty) {
      outputLines.add('');
    }
    outputLines.add(line);
  }

  return outputLines.join('\n');
}
