# From dataset `trds` build a `ctree()` conditional tree.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-01-16 09:24:31 +1100 Graham Williams>
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

# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/conditional-decision-tree.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# 20250116 gjw Choose to use partykit (2015) over the older party
# (2008) package. The partykit package can do much more and is a
# framework for supporting other tree packages including rpart, rweka,
# and pmml.

library(partykit)     # Enhanced visualization and interpretation

# Define the model type and description for file paths and titles

mtype <- "ctree"
mdesc <- "Conditional Inference Tree"

# 20250108 gjw Setup the model build parameters.

control <- ctree_control(
  MINSPLIT, MINBUCKET, MAXDEPTH
)

# Train a Conditional Inference Tree model using ctree.

model_ctree <- partykit::ctree(
  formula   = form,
  data      = trds,
  na.action = na.exclude,
  control   = control
)

# Output a textual view of the Conditional Inference Tree model.

print(model_ctree)
summary(model_ctree)
cat("\n")

# Plot the resulting Conditional Inference Tree.

svg("TEMPDIR/model_tree_ctree.svg")
plot(model_ctree, main=paste("Conditional Inference Tree", target))
dev.off()
