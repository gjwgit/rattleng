/// Check if the target variable has missing values.
//
// Time-stamp: <Thursday 2024-07-18 16:48:49 +1000 Graham Williams>
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

import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/utils/get_target.dart';

/// Checks if the target variable has any missing values.
///
/// Returns true if the target has missing values, false otherwise.
/// Also returns false if no target is set or if the target doesn't exist in metadata.

bool hasTargetMissingValues(WidgetRef ref) {
  // Get the target variable name.

  final target = getTarget(ref);

  // If there's no target set, return false.

  if (target == 'NULL' || target.isEmpty) {
    return false;
  }

  // Get the metadata for all variables.

  final metaData = ref.read(metaDataProvider);

  // Check if the target exists in metadata and has missing values.

  if (metaData.containsKey(target) &&
      metaData[target]!.containsKey('missing') &&
      metaData[target]!['missing'] != null) {
    // Check if the missing value is greater than 0
    // The missing value is stored as a list with a single value.

    final missingCount = metaData[target]!['missing'][0];

    return missingCount > 0;
  }

  return false;
}
