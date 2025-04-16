# Generate a scatterplot matrix for cluster visualization.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2025-04-15 15:21:42 +1000 Graham Williams>
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
# Author: Zheyuan Xu
#
# <TIMESTAMP>
#
# This script generates a scatterplot matrix (pairs plot) for any clustering model.
# It works with KMeans, EWKM, Hierarchical, and BiCluster models.

cluster_type <- '<CLUSTER_TYPE_STR>'

# Determine which model type we're dealing with and extract the cluster assignments.

if (cluster_type == 'KMeans') {
  cluster_assignments <- model_kmeans$cluster
} else if (cluster_type == 'Ewkm') {
  cluster_assignments <- model_ewkm$cluster
} else if (cluster_type == 'Hierarchical') {
  # For hierarchical clustering, we need to check if cluster assignments exist.

  if (!exists("cluster_assignments")) {
    # If cluster_assignments don't exist, cut the tree to get clusters.

    cluster_assignments <- cutree(model_hclust, k = <CLUSTER_NUM>)
  }
} else if (cluster_type == 'BiCluster') {
  # BiCluster does not support pairs plot.

  cat("BiCluster does not support pairs plot.\n")

  return(NULL)
} else {
  # No recognized clustering model found.

  cat("Error: No clustering model found. Please run a clustering algorithm first.\n")

  return(NULL)
}

# Select a sample from the dataset to make the plot more readable.
# Use a fixed seed for reproducibility.

set.seed(<RANDOM_SEED>)
smpl <- sample(nrow(tds))

# Keep just the first 5 variables for the plot.

vars <- 1:min(5, ncol(tds))

# Generate the scatterplot matrix.

svg("<TEMPDIR>/model_cluster_pairs_<CLUSTER_TYPE_STR>.svg")

# Create a title based on the model type
plot_title <- paste(cluster_type, "Cluster Visualization")

# Generate the scatterplot matrix.

pairs(tds[smpl, vars], 
      col = cluster_assignments[smpl],
      main = plot_title,
      pch = 20,  # Use small filled circles for points
      cex = 0.6) # Make points smaller for clearer visualization

# Add a subtitle with timestamp.

mtext(paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]),
      side = 1, line = 4, cex = 0.8)

dev.off()
