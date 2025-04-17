# Generate a scatterplot matrix for cluster visualization.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-04-17 14:26:24 +1000 Graham Williams>
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
# This script generates a scatterplot matrix (pairs plot) for any
# clustering model.  It works with KMeans, EWKM, Hierarchical, and
# BiCluster models. We first identify the type of cluster we want a
# pairs plot for. (zh 20250417)

# Select a sample from the dataset to make the plot more readable.
# Use a fixed seed for reproducibility.

set.seed(<RANDOM_SEED>)
smpl <- sample(nrow(tds))

# RattleV5 would keep just the first 5 variables for the plot. More
# than 5 is visually crowded. But we now have zoom so let's try no
# limitation.

vars <- 1:ncol(tds) # min(5, ncol(tds))

# Create a title based on the model type.

plot_title <- paste("Pairwise", mdesc, "Visualization -", mtype)

# Generate the scatterplot matrix.

svg(glue("<TEMPDIR>/{pair_file}"))
pairs(tds[smpl, vars],
      col  = cluster_assignments[smpl],
      main = plot_title,
      pch  = 20,  # Use small filled circles for points
      cex  = 0.6) # Make points smaller for clearer visualization
mtext(paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]),
      side = 1, line = 4, cex = 0.8)
dev.off()
