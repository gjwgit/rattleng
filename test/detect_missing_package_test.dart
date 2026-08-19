/// Test the detection of R packages that are missing or fail to load.
//
// Time-stamp: <Wednesday 2026-08-19 11:30:00 +1000 Graham Williams>
//
/// Copyright (C) 2026, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/utils/detect_missing_package.dart';

// To exercise the advice in the running app, rather than just this detection,
// make R refuse a package it does have. Put this in a file and start Rattle
// with `R_PROFILE_USER` pointing at it, and every `library(ggplot2)` fails the
// way R fails for a package that is not installed, leaving the rest alone:
//
//   library <- function(...) {
//     args <- as.list(substitute(list(...)))[-1L]
//     nm <- as.character(args[[1L]])
//     if (nm %in% c("ggplot2")) {
//       stop(sprintf("there is no package called '%s'", nm))
//     }
//     eval.parent(as.call(c(quote(base::library), args)))
//   }
//
// Name a package per action to check the advice comes back for each of them:
// ggplot2 is loaded as the dataset loads, randomForest as a forest is built.
// Note that a script reaching a package as `ggplot2::ggplot()` rather than
// through `library()` is untouched by this. (gjw 20260819)

void main() {
  group('detectMissingPackages', () {
    test('nothing wrong reports nothing', () {
      expect(detectMissingPackages('> summary(ds)\n> '), isEmpty);
    });

    test('a package that is not installed', () {
      expect(
        detectMissingPackages(
          "Error in library(arules) : there is no package called 'arules'",
        ),
        ['arules'],
      );
    });

    test('R curly quotes as well as ASCII', () {
      expect(
        detectMissingPackages(
          'Error in library(arules) : there is no package called ‘arules’',
        ),
        ['arules'],
      );
    });

    // The wording of a load failure, as seen on kadesh with the R library path
    // pointed elsewhere so that ggplot2 could not load. (gjw 20260819)

    test('a package that fails to load', () {
      expect(
        detectMissingPackages(
          'Error: package or namespace load failed for ‘ggplot2’ in '
          'dyn.load(file, DLLpath = DLLpath, ...):\n unable to load shared '
          "object '/usr/lib/R/site-library/rlang/libs/rlang.so'",
        ),
        ['ggplot2'],
      );
    });

    // 20260819 gjw Every package, so that the advice names the lot and the user
    // installs them in one go rather than meeting the next one on each retry.

    test('every package named, in the order R reported them', () {
      expect(
        detectMissingPackages(
          "there is no package called 'arules'\n"
          "there is no package called 'arulesViz'\n",
        ),
        ['arules', 'arulesViz'],
      );
    });

    test('the same package reported twice is named once', () {
      expect(
        detectMissingPackages(
          "there is no package called 'arules'\n"
          "Error in library(arules) : there is no package called 'arules'\n",
        ),
        ['arules'],
      );
    });

    test('a name reported both ways is named once', () {
      expect(
        detectMissingPackages(
          "there is no package called 'ggplot2'\n"
          "package or namespace load failed for 'ggplot2'\n",
        ),
        ['ggplot2'],
      );
    });
  });
}
