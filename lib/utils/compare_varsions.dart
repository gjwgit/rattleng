/// Compare version s in the form of major.minor.patch.
//
// Time-stamp: <Wednesday 2025-01-29 12:03:20 +1100 Graham Williams>
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
/// Authors: Deep Seek, Graham Williams

library;

/// Compare versions [v1] and [v2] with 0 if same, 1 if v1>v2 and -1 if v1<v2.

int compareVersions(String v1, String v2) {
  // Split the version strings into lists of integers.

  List<int> version1 = v1.split('.').map((e) => int.parse(e)).toList();
  List<int> version2 = v2.split('.').map((e) => int.parse(e)).toList();

  // Determine the maximum length to iterate.

  int maxLength =
      version1.length > version2.length ? version1.length : version2.length;

  for (int i = 0; i < maxLength; i++) {
    // If one version has fewer components, assume 0 for the missing components.

    int part1 = i < version1.length ? version1[i] : 0;
    int part2 = i < version2.length ? version2[i] : 0;

    if (part1 < part2) {
      return -1; // v1 is less than v2.
    } else if (part1 > part2) {
      return 1; // v1 is greater than v2.
    }
  }

  return 0; // v1 is equal to v2.
}
