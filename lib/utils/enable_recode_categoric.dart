/// Check for whether chr variable can be recoded as categoric.
//
// Time-stamp: <Thursday 2025-03-27 07:24:40 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_vars.dart';

/// Determines if a variable can be recoded as categorical based on its type.
///
/// Is [var] of type 'chr' and so can be recoded as categoric?

bool enableRecodeCategoric(String vname, WidgetRef ref) {
  // TODO CLEANSE should be irrelevant here. VARS should be extracted from
  // metaDataProvider. (gjw 20250327)

  final cleanse = ref.watch(cleanseProvider);

  String stdout = ref.watch(stdoutProvider);

  List<VariableInfo> vars = extractVariables(stdout);

  if (!cleanse) {
    for (var v in vars) {
      if (v.name == vname && (v.type == 'chr' || v.type == 'ord')) {
        return true;
      }
    }
  }

  return false;
}
