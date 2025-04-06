/// Utility to extract the latest summary(ds) output from R.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-08-10 17:51:29 +1000 Graham Williams>
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

import 'dart:io' show Platform;

import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/clean_string.dart';

String rExtractSummary(String txt) {
  String content = rExtract(txt, '> summary(ds)');

  // Normalize line endings for platform independence.

  if (Platform.isWindows) {
    content = content.replaceAll('\r\n', '\n');
  }

  // Extract variable names from the dataset.

  List<VariableInfo> vars = extractVariables(txt);
  List<String> varNames = vars.map((v) => v.name).toList();

  // Add a blank line between each sub-table.

  List<String> lines = content.split('\n');

  // Process each line to add spacing between variable summaries.

  for (int i = 0; i < lines.length; i++) {
    // Check if this appears to be a variable headers row by comparing with known variable names.

    if (i > 0 &&
        lines[i].trim().isNotEmpty &&
        !lines[i].trim().startsWith('> ')) {
      if (isHeaderRowWithVariables(lines[i], varNames)) {
        // Add an empty line before the variable header row.

        lines[i] = '\n${lines[i]}';
        continue;
      }
    }
  }

  // Join lines with platform-appropriate line endings.

  String separator = Platform.isWindows ? '\r\n' : '\n';
  content = lines.join(separator);

  // Replace multiple empty lines with a single empty line.

  if (Platform.isWindows) {
    content = content.replaceAll(RegExp(r'\r\n\s*\r\n\s*\r\n+'), '\r\n\r\n');
  } else {
    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');
  }

  // Clean the result.

  content = cleanString(content);

  return content;
}

/// Checks if a line is a header row by matching its contents against known variable names.
///
/// This compares the words in the line with the list of variable names extracted from the dataset.
/// The line is considered a header row only if ALL words match variable names.

bool isHeaderRowWithVariables(String line, List<String> varNames) {
  // Trim the line and split into words.

  String trimmedLine = line.trim();
  List<String> words = trimmedLine.split(RegExp(r'\s+'));

  // Check that every word matches a variable name.

  for (String word in words) {
    // Clean up the word (remove any punctuation that might be present).

    String cleanWord = word.replaceAll(RegExp(r'[^\w\d_]'), '');

    if (cleanWord.isEmpty) continue;

    // If any word doesn't match a variable name, this isn't a header row

    if (!varNames.contains(cleanWord)) {
      return false;
    }
  }

  // All words matched variable names (and we had at least one word).

  return words.isNotEmpty;
}
