# Rattle Scripts: From dataset ds build a conditional inference tree.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-07-20 14:58:29 +1000 Graham Williams>
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

# Load required packages for conditional inference trees
if (!requireNamespace("party", quietly = TRUE)) {
  install.packages("party")
}
if (!requireNamespace("partykit", quietly = TRUE)) {
  install.packages("partykit")
}

library(party)       # Conditional inference trees
library(partykit)    # Enhanced visualization and interpretation

# Define model type and description
mtype <- "ctree"
mdesc <- "Conditional Inference Tree"

# Determine what type of model to build based on the number of values of the target variable
# Not needed for ctree as it automatically handles the data type

# Define the formula for the model
form <- as.formula(paste(target, "~ ."))

control <- ctree_control(
  MINSPLIT, MINBUCKET, MAXDEPTH
)

# Train a Conditional Inference Tree model using ctree
model_ctree <- ctree(
  formula = form,
  data = ds[tr, vars],
  control = control
)

# Generate a textual view of the Conditional Inference Tree model
print(model_ctree)
summary(model_ctree)
cat("\n")

# Plot the resulting Conditional Inference Tree
svg("TEMPDIR/model_tree_ctree.svg")
plot(model_ctree, main = paste("Conditional Inference Tree", target))
dev.off()

# Output a message when execution is complete
print("Execution Completed")
