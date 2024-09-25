/// Utility to extract the latest CLUSTER from R log.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-06-09 16:42:30 +1000 Graham Williams>
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

import 'package:rattle/providers/cluster_number.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/timestamp.dart';

String _basicTemplate(
  String log,
  WidgetRef ref,
) {
  // Here we build up the basic information from the output of the cluster.

  // First some strings to put into the output.

  int clusterNum = ref.read(clusterNumberProvider.notifier).state;

  const String hd = 'Summary of the KMeans Cluster Analysis';
  String md = "(built using 'kmeans' with ${clusterNum.toString()} clusters):";

  // No extract the output from particular commands.

  final String sz = rExtract(log, '> print(paste(model_kmeans');
  final String cm = rExtract(log, '> print(colMeans');
  final String cn = rExtract(log, '> print(model_kmeans\$centers');
  final String ss = rExtract(log, '> print(model_kmeans\$withinss)');

  // Obtain the current timestamp.

  final String ts = timestamp();

  // Build the result.

  String result = '';

  if (sz != '') {
    result = '$hd $md\n\nCluster Sizes:\n$sz\n\n'
        'Cluster Means:\n$cm\n\n'
        'Cluster Centers:\n$cn\n\n'
        'Cluster Within Sum of Squares\n$ss\n\n'
        'Rattle timestamp: $ts';
  }

  return result;
}

String rExtractCluster(
  String log,
  WidgetRef ref,
) {
  // Extract from the R log those lines of output from the cluster.

  String extract = _basicTemplate(log, ref);

  // Now clean up the output for an annotated presentation of the output.

  // Give there are 10 clusters, for the cluster centers add a separating blank
  // line after each group of centers, for the case where the variables are more
  // than fit on one line.

  final pattern = RegExp(r'\n10.*?(?=\n)');

  extract = extract.replaceAllMapped(pattern, (match) {
    return '${match.group(0)}\n';
  });

  return extract;
}
