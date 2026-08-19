/// Detect a missing R package from R console output.
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
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
/// Authors: Graham Williams

library;

/// When an R `library()` or `requireNamespace()` call fails because a package
/// is not installed, R prints one of a few characteristic messages, e.g.:
///
///   Error in library(arules) : there is no package called 'arules'
///   Error: package or namespace load failed for 'arulesViz' ...
///   there is no package called 'arules'
///
/// The downstream R objects (e.g. `ds`, `model_arules`) are then never created
/// and the corresponding display panel renders blank (a "grey screen"), or in
/// debug mode throws when it tries to access the missing result. We scan the
/// accumulated R console output for this signature so the app can advise the
/// user to install the required R packages.
///
/// Returns the names of every missing package found, in the order R reported
/// them and without repeats, or an empty list where the output holds no
/// missing-package error.
///
/// 20260819 gjw All of them rather than just the first. One script can want
/// several packages, and naming them together means the user installs the lot
/// in one go instead of finding the next one missing on every retry.

List<String> detectMissingPackages(String stdout) {
  // The canonical phrase R uses, regardless of whether the failure came via
  // `library()`, `require()`, or `requireNamespace()`. Capture the quoted
  // package name. R uses ASCII single quotes here.

  final RegExp noPackage = RegExp(
    r"there is no package called ['\u2018]([A-Za-z0-9._]+)['\u2019]",
  );

  // A namespace load failure also indicates an unusable/missing package. This
  // is a softer signal (the package may exist but fail to load) but from the
  // user's point of view the remedy is the same: (re)install packages.

  final RegExp loadFailed = RegExp(
    r"package or namespace load failed for ['\u2018]([A-Za-z0-9._]+)['\u2019]",
  );

  final List<String> found = [];

  for (final RegExp pattern in [noPackage, loadFailed]) {
    for (final Match m in pattern.allMatches(stdout)) {
      final String name = m.group(1)!;
      if (!found.contains(name)) found.add(name);
    }
  }

  return found;
}
