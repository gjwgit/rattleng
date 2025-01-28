/// Gets frequency vector of target variable.
//
// Time-stamp: <Monday 2024-12-16 08:18:30 +1100 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

List<int> getTargetFrequency(WidgetRef ref) {
  String stdout = ref.watch(stdoutProvider);

  final randomPartition = ref.watch(partitionProvider);

  try {
    // Extract frequencies of target variable classes from R output.
    // If randomPartition is true, calculate ceiling of frequencies scaled by DATA_SPLIT_TR_TU_TE.

    String defineTarget = rExtract(
        stdout,
        randomPartition
            ? '> ceiling(as.numeric(table(ds[[target]])) * split[1])'
            : '> as.numeric(table(ds[[target]]))');

    // Remove [1] prefix if present.

    defineTarget = defineTarget.replaceAll(RegExp(r'^\[1\]\s*'), '');

    // Split string into numbers and convert to integers.

    List<int> frequencies = defineTarget
        .trim()
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s) ?? 0)
        .toList();

    return frequencies.length == 2 ? frequencies : [0, 0];
  } catch (e) {
    return [0, 0]; // Return default on error.
  }
}
