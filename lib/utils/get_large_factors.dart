/// Utility to extract the large factors output from R.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-05-19 07:07:31 +1000 Graham Williams>
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
import 'package:rattle/providers/meta_data.dart';

/// Returns a list of factor variables that have more unique values than the maxFactor threshold.
/// A factor is considered "large" if its number of unique values exceeds maxFactor.

List<String> getLargeFactors(WidgetRef ref) {
  final Map<String, dynamic> metaData = ref.read(metaDataProvider);

  final int maxFactor = ref.read(maxFactorProvider);

  List<String> largeFactors = [];

  metaData.forEach((varName, varData) {
    if (varData['datatype']?.contains('factor') ||
        varData['datatype']?.contains('character') ||
        varData['datatype']?.contains('ordered')) {
      final uniqueCount = varData['unique']?[0] ?? 0;
      if (uniqueCount >= maxFactor) {
        largeFactors.add(varName);
      }
    }
  });

  return largeFactors;
}
