/// Utility to extract the latest CLUSTER from R log.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-09-27 05:39:57 +1000 Graham Williams>
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

import 'package:rattle/providers/cluster.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/timestamp.dart';

String _basicTemplate(
  String log,
  WidgetRef ref,
) {
  // Here we build up the basic information from the output of the cluster.

  // First some strings to put into the output.

  int clusterNum = ref.read(numberClusterProvider.notifier).state;

  String hd;
  String md;

  String type = ref.read(typeClusterProvider.notifier).state;
  type = type.toLowerCase();

  if (type == 'kmeans') {
    hd = 'Summary of the KMeans Cluster Analysis';
    md = "(built using 'kmeans' with ${clusterNum.toString()} clusters):";
  } else if (type == 'ewkm') {
    hd = 'Summary of the Ewkm Cluster Analysis';
    md = "(built using 'ewkm' with ${clusterNum.toString()} clusters):";
  } else if (type == 'hierarchical') {
    hd = 'Summary of the Hierarchical Cluster Analysis';
    md = "(built using 'Hierarchical'):";
  } else if (type == 'bicluster') {
    hd = 'Summary of the Bi-Cluster Analysis';
    md = "(built using 'BiCluster'):";
  } else {
    // Handle other types or return an empty result.

    return '';
  }

  // Now extract the output from particular commands.

  String sz = '', cm = '', cn = '', ss = '';

  if (type == 'kmeans') {
    sz = rExtract(log, '> print(paste(model_kmeans');
    cm = rExtract(log, '> print(colMeans');
    cn = rExtract(log, '> print(model_kmeans\$centers');
    ss = rExtract(log, '> print(model_kmeans\$withinss)');
  } else if (type == 'ewkm') {
    sz = rExtract(log, "> print(paste(model_ewkm\$size, collapse = ' '))");
    cm = rExtract(log, '> print(colMeans(data_for_clustering))');
    cn = rExtract(log, '> print(model_ewkm\$centers)');
    ss = rExtract(log, '> print(model_ewkm\$withinss)');
  } else if (type == 'hierarchical') {
    sz = rExtract(log, '> print(cluster_sizes)');
    cm = rExtract(log, '> print(data_means)');
    cn = rExtract(log, '> print(cluster_centers)');
    ss = rExtract(log, '> print(withinss)');
  } else if (type == 'bicluster') {
    sz = rExtract(log, '> print(cluster_sizes)');
    cm = rExtract(log, '> print(cluster_means)');
    cn = rExtract(log, '> print(col_clusters)');
    ss = rExtract(log, '> print(withinss)');
  }

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

  // Given there are 10 clusters, for the cluster centers add a separating blank
  // line after each group of centers, for the case where the variables are more
  // than fit on one line.

  final pattern = RegExp(r'\n10.*?(?=\n)');

  extract = extract.replaceAllMapped(pattern, (match) {
    return '${match.group(0)}\n';
  });

  return extract;
}
