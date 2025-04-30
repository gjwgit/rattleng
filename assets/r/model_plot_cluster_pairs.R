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

# Attempt to convert the input pair size setting (<CLUSTER_PAIR_SIZE>)
# to a usable numeric value.

raw_pair_size_input <- <CLUSTER_PAIR_SIZE>

# Convert to numeric, suppressing warnings for non-numeric input (which becomes NA).
# Use floor() to ensure we have an integer value if conversion is successful.

pair_size_num <- suppressWarnings(floor(as.numeric(raw_pair_size_input)))

# Validate the converted number:
# 1. Check length: Must be exactly 1. This handles cases like NULL input,
#    where as.numeric(NULL) results in numeric(0) which has length 0.
#    It passes for valid single numbers (e.g., length(5) is 1, length(12) is 1).
# 2. Check for NA: Must not be NA. This handles non-numeric string inputs.
# 3. Check value: Must be at least 1 (pair size must be positive).

is_valid_input <- length(pair_size_num) == 1 && !is.na(pair_size_num) && pair_size_num >= 1

# Determine the final pair size using ifelse (avoids explicit if/else block):
# - If input is valid: use the minimum of the validated input number and the
#   total number of columns in the dataset (tds).
# - If input is invalid (e.g., NULL, non-numeric string, zero, negative):
#   use the total number of columns as the fallback pair size.

pair_size <- ifelse(is_valid_input,min(pair_size_num, ncol(tds)), ncol(tds))

# Ensure the final pair_size is not negative (important if ncol(tds) could be 0).

pair_size <- max(1, pair_size)

vars <- 1:pair_size

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
