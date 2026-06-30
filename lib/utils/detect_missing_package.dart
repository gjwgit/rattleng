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
/// Returns the name of the first missing package found, or `null` if the
/// output does not contain a missing-package error.

String? detectMissingPackage(String stdout) {
  // The canonical phrase R uses, regardless of whether the failure came via
  // `library()`, `require()`, or `requireNamespace()`. Capture the quoted
  // package name. R uses ASCII single quotes here.

  final RegExp noPackage = RegExp(
    r"there is no package called ['\u2018]([A-Za-z0-9._]+)['\u2019]",
  );

  final Match? m = noPackage.firstMatch(stdout);
  if (m != null) return m.group(1);

  // A namespace load failure also indicates an unusable/missing package. This
  // is a softer signal (the package may exist but fail to load) but from the
  // user's point of view the remedy is the same: (re)install packages.

  final RegExp loadFailed = RegExp(
    r"package or namespace load failed for ['\u2018]([A-Za-z0-9._]+)['\u2019]",
  );

  final Match? m2 = loadFailed.firstMatch(stdout);
  if (m2 != null) return m2.group(1);

  return null;
}
