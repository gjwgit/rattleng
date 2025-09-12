/// Map boost feature template patterns to their values.
///
// Time-stamp: "Friday 2025-09-12 13:52:58 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/boost.dart';

/// Map boost template patterns in [code] to their current values.

String mapBoost(WidgetRef ref, String code) {
  // Obtain the current values of the global variables.

  int boostIterations = ref.read(iterationsBoostProvider);
  int boostMaxDepth = ref.read(maxDepthBoostProvider);
  int boostMinSplit = ref.read(minSplitBoostProvider);
  int boostThreads = ref.read(threadsBoostProvider);
  int boostXVal = ref.read(xValueBoostProvider);

  double boostComplexity = ref.read(complexityBoostProvider);
  double boostLearningRate = ref.read(learningRateBoostProvider);

  String boostObjective = ref.read(objectiveBoostProvider);

  // Perform the mapping.

  code = code.replaceAll('<BOOST_MAX_DEPTH>', boostMaxDepth.toString());
  code = code.replaceAll('<BOOST_MIN_SPLIT>', boostMinSplit.toString());
  code = code.replaceAll('<BOOST_X_VALUE>', boostXVal.toString());
  code = code.replaceAll('<BOOST_LEARNING_RATE>', boostLearningRate.toString());
  code = code.replaceAll('<BOOST_COMPLEXITY>', boostComplexity.toString());
  code = code.replaceAll('<BOOST_THREADS>', boostThreads.toString());
  code = code.replaceAll('<BOOST_ITERATIONS>', boostIterations.toString());
  code = code.replaceAll('<BOOST_OBJECTIVE>', '"$boostObjective"');

  return (code);
}
