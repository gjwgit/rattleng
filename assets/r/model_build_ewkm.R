# Build an Ewkm cluster.
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

# Cluster using KMeans
#
# <TIMESTAMP>
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

# set.seed(<RANDOM_SEED>)

# Load required packages from the local library into the R session.
# The 'reshape' package provides the 'rescaler' function.

library(reshape)
library(wskm)         # Load the wskm package for EWKM

mtype <- "ewkm"
mdesc <- "Entropy Weighted K-Means Cluster"

# Set whether the data should be rescaled. For cluster analysis this
# is usually recommended.

rescale <- <CLUSTER_RESCALE>

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

# Generate an EWKM cluster model.

model_ewkm <- ewkm(tds, centers=<CLUSTER_NUM>)

# Report on the cluster characteristics.

# Cluster sizes:

print(paste(model_ewkm$size, collapse = ' '))

# Data means:

print(colMeans(tds))

# Cluster centers:

print(model_ewkm$centers)

# Within-cluster sum of squares:

print(model_ewkm$withinss)

cat("\n")

# Plot the first two principal components, which serve as discriminant coordinates.

svg("<TEMPDIR>/model_cluster_ewkm.svg")

# Generate a discriminant coordinates plot.

# Convert tds to a matrix if it's not already.

tds_matrix <- as.matrix(tds)

# Generate the clusplot.

cluster::clusplot(tds_matrix, model_ewkm$cluster, color=TRUE, shade=TRUE,
                  labels=2, lines=0, main='Discriminant Coordinates Plot')

dev.off()

svg("<TEMPDIR>/model_cluster_ewkm_weights.svg")


# Create a bar plot of cluster weights.

plot(levelplot(model_ewkm))

# Close the SVG device for the weights plot.

dev.off()
