# Rattle Scripts: From dataset ds build a kmeans cluster.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-14 20:29:04 +1000 Graham Williams>
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
# Author: Graham Williams

# Cluster using KMeans
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/cluster-analysis.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# The 'reshape' package provides the 'rescaler' function.

library(reshape)

mtype <- "kmeans"
mdesc <- "Cluster"

# Generate a kmeans cluster of size 10.

model_kmeans <- kmeans(sapply(na.omit(ds[tr, numc]), rescaler, "range"), 10)

# Report on the cluster characteristics. 

# Cluster sizes:

print(paste(model_kmeans$size, collapse=' '))

# Data means:

print(colMeans(sapply(na.omit(ds[tr, numc]), rescaler, "range")))

# Cluster centers:

print(model_kmeans$centers)

# Within cluster sum of squares:

print(model_kmeans$withinss)

cat("\n")
