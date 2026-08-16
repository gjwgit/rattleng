/// Utility to extract the formula from the R log.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Monday 2024-12-16 08:14:06 +1100 Graham Williams"
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

import 'package:rattle/r/extract.dart';

/// Extract from the R [log] the model formula as printed by `print(form)`.
///
/// 20260630 gjw The previous implementation returned everything between the
/// `> print(form)` console line and the next `> ` prompt. When the R script is
/// echoed to the console, the source of the `if (...) form <- formula(...)`
/// block and its continuation (`+ `) lines can land in that region, producing
/// noise such as a bare `))` and an `if ...` fragment ahead of the actual
/// formula (e.g. `Formula: ))` then `if rain_tomorrow ~ .`). R prints a formula
/// object as a single line of the form `target ~ .` (or `~ .` when there is no
/// target), so we pull that line out directly and ignore the echoed source.

String rExtractFormula(String log) {
  final String region = rExtract(log, '> print(form)');

  // A printed formula line contains a `~`. Pick the first line that looks like
  // a formula. Echoed source can bleed a leading `if ` (from the
  // `if (...) form <- formula(...)` block) onto the formula line, so we strip a
  // leading `if ` before matching. Lines that are clearly echoed source
  // (starting with `>`/`+`, or containing `formula(`/`{`/`}`) are ignored.

  final RegExp formulaLine = RegExp(r'^([A-Za-z0-9._]+\s*)?~\s*\S.*$');

  String? best;

  for (final String raw in region.split('\n')) {
    String trimmed = raw.trim();

    if (trimmed.isEmpty) continue;
    if (trimmed.startsWith('>') || trimmed.startsWith('+')) continue;
    if (trimmed.contains('formula(') ||
        trimmed.contains('{') ||
        trimmed.contains('}')) {
      continue;
    }

    // Strip a leading `if ` that can leak in from the echoed source block.

    if (trimmed.startsWith('if ')) {
      trimmed = trimmed.substring(3).trim();
    }

    if (formulaLine.hasMatch(trimmed)) {
      best = trimmed;
      break;
    }
  }

  if (best != null) return best;

  // Fall back to the raw region (trimmed) if no formula-shaped line was found,
  // so we degrade to the previous behaviour rather than returning nothing.

  return region.trim();
}
