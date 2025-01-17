# Undertake BiCluster analysis.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-10-19 06:50:01 +1100 Graham Williams>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but <WITHOUT>
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Zheyuan Xu, Graham Williams

# Cluster analysis using BiCluster
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/cluster-analysis.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.
# The 'reshape' package provides the 'rescaler' function.

library(reshape)
library(biclust)

mtype <- "bicluster"
mdesc <- "BiCluster cluster analysis"

# Set whether the data should be rescaled.

rescale <- <CLUSTER_RESCALE>

# Prepare the data for bi-clustering based on the value of rescale.

if (rescale) {
  # Rescale the data.
  tds <- sapply(na.omit(ds[tr, numc]), reshape::rescaler, "range")
} else {
  # Use the data without rescaling.
  tds <- na.omit(ds[tr, numc])
}

# Convert data to matrix if necessary.

tds <- as.matrix(tds)

# Perform bi-clustering using the biclust function.

model_biclust <- biclust(tds, method=BCCC(), number=<CLUSTER_NUM>)

# Extract row and column clusters.

row_clusters <- model_biclust@RowxNumber
col_clusters <- model_biclust@NumberxCol

print("Row Clusters:")
print(row_clusters)
print("Column Clusters:")
print(col_clusters)

# Add the bi-cluster assignments to the data frame (optional).

row_cluster_assignments <- apply(row_clusters, 1, function(row) which(row == 1))
tds_with_biclusters <- data.frame(tds, row_cluster = row_cluster_assignments)

# Report on the bi-cluster characteristics.

cluster_sizes <- colSums(row_clusters)
print("Row Cluster Sizes:")
print(cluster_sizes)

# Compute mean for each row cluster (aggregated data).

cluster_means <- aggregate(tds, by = list(cluster = row_cluster_assignments), FUN = mean)
print("Cluster Means:")
print(cluster_means)

# Within-cluster sum of squares:

withinss <- sapply(split(as.data.frame(tds), row_cluster_assignments), function(cluster_data) {
  center <- colMeans(cluster_data)
  sum(rowSums((cluster_data - center)^2))
})
print("Within-Cluster Sum of Squares:")
print(withinss)
