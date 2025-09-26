/// Map rpart feature template patterns to their values.
///
// Time-stamp: "Friday 2025-09-12 14:06:07 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/tree.dart';

/// Map boost template patterns in [code] to their current values.

String mapRpart(WidgetRef ref, String code) {
  // Obtain the current values of the global variables.

  int minSplit = ref.read(treeMinSplitProvider);
  int maxDepth = ref.read(treeMaxDepthProvider);
  int minBucket = ref.read(treeMinBucketProvider);

  bool treeIncludeMissing = ref.read(treeIncludeMissingProvider);

  double complexity = ref.read(treeComplexityProvider);

  String lossMatrix = ref.read(treeLossMatrixProvider);
  String priors = ref.read(treePriorsProvider);

  // Perform the mapping.

  code = code.replaceAll(
    '<RPART_INCLUDE_MISSING>',
    treeIncludeMissing
        ? ''
        : 'usesurrogate = 0,\n                          maxsurrogate = 0,\n                          ',
  );
  code = code.replaceAll('<MINSPLIT>', 'minsplit     = ${minSplit.toString()}');
  code = code.replaceAll(
    '<MINBUCKET>',
    'minbucket    = ${minBucket.toString()}',
  );
  code = code.replaceAll('<MAXDEPTH>', 'maxdepth     = ${maxDepth.toString()}');
  code = code.replaceAll('<CP>', 'cp           = ${complexity.toString()}');
  code = code.replaceAll(
    '<PRIORS>',
    priors.isNotEmpty ? ', prior = c($priors)' : '',
  );
  code = code.replaceAll(
    '<LOSS>',
    lossMatrix.isNotEmpty ? ', loss = matrix(c($lossMatrix))' : '',
  );

  return (code);
}
