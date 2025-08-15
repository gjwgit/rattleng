/// DESCRIPTION
///
// Time-stamp: "Saturday 2025-04-12 09:56:07 +1000 Graham Williams"
///
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
/// Authors:

library;
// Function to parse the input text

Map<String, List<String>> parsePackage(String text) {
  final Map<String, List<String>> datasetsMap = {};
  final lines = text.split('\n'); // Split input into lines
  String? currentPackage; // To store the current package name

  for (var line in lines) {
    line = line.trim(); // Remove leading and trailing spaces
    if (line.startsWith(r'$')) {
      // If line starts with $, it's a package name
      currentPackage = line.substring(
        1,
      ); // Remove the $ and store the package name
      datasetsMap[currentPackage] = []; // Initialize an empty list for datasets
    } else if (line.contains('"') && currentPackage != null) {
      // If line contains dataset names (quoted), extract them separately
      final regex = RegExp(r'"(.*?)"'); // Regex to match each quoted string
      final matches = regex.allMatches(line);
      for (var match in matches) {
        // debugPrint("dataset is ${match.group(1)!}");
        // Add each match as a separate dataset
        datasetsMap[currentPackage]?.add(match.group(1)!);
      }
    }
  }

  return datasetsMap;
}
