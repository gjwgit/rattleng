# Rattle Scripts: From dataset ds build a kmeans cluster.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-10-12 18:52:02 +1100 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
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
# Author: Graham Williams

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

mtype <- "kmeans"
mdesc <- "Cluster"

# Set whether the data should be rescaled. For cluster analysis this
# is usually recommended.

rescale <- <CLUSTER_RESCALE>

# Prepare the data for clustering based on the value of rescale.

if (rescale) {

  # Rescale the data.

  tds <- sapply(na.omit(ds[tr, numc]), reshape::rescaler, "range")

} else {

  # Use the data without rescaling.

  tds <- na.omit(ds[tr, numc])
  
}


# Generate a kmeans cluster of size 10.

model_kmeans <- kmeans(tds,
                       centers=<CLUSTER_NUM>,
                       nstart=<CLUSTER_RUN>)

# Report on the cluster characteristics. 

# Cluster sizes:

print(paste(model_kmeans$size, collapse=' '))

# Data means:

print(colMeans(tds))

# Cluster centers:

print(model_kmeans$centers)

# Within cluster sum of squares:

print(model_kmeans$withinss)

cat("\n")

# Plot the first two principal components, which serve as discriminant coordinates.

svg("<TEMPDIR>/model_cluster_discriminant.svg")

# Generate a discriminant coordinates plot.

# Convert tds to a matrix if it's not already.

tds_matrix <- as.matrix(tds)

# Generate the clusplot.

cluster::clusplot(tds_matrix, model_kmeans$cluster, color=TRUE, shade=TRUE,
                  labels=2, lines=0, main='Discriminant Coordinates Plot')
dev.off()
