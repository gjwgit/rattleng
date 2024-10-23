# Build an Hierarchical cluster.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-10-12 18:45:49 +1100 Graham Williams>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Graham Williams, Zheyuan Xu

# Cluster using Hierarchical
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/cluster-analysis.html
# https://survivor.togaware.com/datascience/ for further details.

# Reset the random number seed to obtain the same results each
# time. 20241012 gjw RattleV5 did not reset the seed so that we can
# demonstrate that each time we get a different random start and then
# a different model.

# set.seed(CLUSTER_SEED)

# Load required packages from the local library into the R session.
# The 'reshape' package provides the 'rescaler' function.

library(reshape)
library(amap)

mtype <- "hierarchical_amap"
mdesc <- "Hierarchical Clustering using amap package"

# Set whether the data should be rescaled
rescale <- CLUSTER_RESCALE

# Prepare the data for clustering based on the value of rescale.

if (rescale) {
  # Rescale the data.

  tds <- sapply(na.omit(ds[tr, numc]),
                reshape::rescaler,
                "range")
} else {
  # Use the data without rescaling.

  tds <- na.omit(ds[tr, numc])
}

# Convert data to matrix if necessary.

tds <- as.matrix(tds)

# Perform hierarchical clustering using the hcluster function from the amap package.

model_hclust <- hcluster(tds, method=CLUSTER_DISTANCE, link=CLUSTER_LINK, nbproc=CLUSTER_PROCESSOR)

# Cut the dendrogram to get the specified number of clusters.

cluster_assignments <- cutree(model_hclust, k = CLUSTER_NUM)

# Add the cluster assignments to the data frame (optional).

tds_with_clusters <- data.frame(tds, cluster = cluster_assignments)

# Report on the cluster characteristics.

# Cluster sizes:

cluster_sizes <- table(cluster_assignments)
print("Cluster Sizes:")
print(cluster_sizes)

# Data means:

data_means <- colMeans(tds)
print("Data Means:")
print(data_means)

# Cluster centers:

cluster_centers <- aggregate(tds, by = list(cluster = cluster_assignments), FUN = mean)
print("Cluster Centers:")
print(cluster_centers)

# Within-cluster sum of squares:

withinss <- sapply(split(as.data.frame(tds), cluster_assignments), function(cluster_data) {
  center <- colMeans(cluster_data)
  sum(rowSums((cluster_data - center)^2))
})
print("Within-Cluster Sum of Squares:")
print(withinss)

cat("\n")

# Plot the dendrogram plot.

svg("TEMPDIR/model_cluster_hierarchical.svg", width = 20, height = 9)  # Adjust width and height as needed

# Convert the hcluster object to an hclust object if necessary.
# This ensures compatibility with the plot function.

model_hclust_hclust <- as.hclust(model_hclust)

# Draw the dendrogram plot.

plot(model_hclust_hclust,
     main = "Hierarchical Clustering Dendrogram",
     sub = paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]),
     xlab = "",
     ylab = "Height")

# Close the SVG device.

dev.off()

