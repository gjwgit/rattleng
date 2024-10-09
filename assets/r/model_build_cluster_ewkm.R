# Rattle Scripts: From dataset ds build an Ewkm cluster.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2024-09-27 05:29:27 +1000 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
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
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/cluster-analysis.html
# https://survivor.togaware.com/datascience/ for further details.

# Reset the random number seed to obtain the same results each time.

set.seed(CLUSTER_SEED)

# Load required packages from the local library into the R session.
# The 'reshape' package provides the 'rescaler' function.

library(reshape)
library(wskm, quietly=TRUE)  # Load the wskm package for EWKM

mtype <- "ewkm"
mdesc <- "Entropy Weighted K-Means Cluster"

# The variable to set whether the model needs rescale.

rescale <- RESCALE

# Prepare the data for clustering based on the value of rescale.

if (rescale) {
  # Rescale the data.

  data_for_clustering <- sapply(na.omit(ds[tr, numc]), rescaler, "range")
} else {
  # Use the data without rescaling.

  data_for_clustering <- na.omit(ds[tr, numc])
}

# Convert data to matrix if necessary.

data_for_clustering <- as.matrix(data_for_clustering)

# Generate an EWKM cluster model.

model_ewkm <- ewkm(
  data_for_clustering,
  centers = CLUSTER_NUM,
)

# Report on the cluster characteristics.

# Cluster sizes:

print(paste(model_ewkm$size, collapse = ' '))

# Data means:

print(colMeans(data_for_clustering))

# Cluster centers:

print(model_ewkm$centers)

# Within-cluster sum of squares:

print(model_ewkm$withinss)

cat("\n")
