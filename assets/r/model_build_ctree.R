# Using the dataset `ds` build a `ctree()` decision tree.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 16:01:40 +1100 Graham Williams>
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

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(party)        # Conditional inference trees
library(partykit)     # Enhanced visualization and interpretation

# Define the model type and description for file paths and titles

mtype <- "ctree"
mdesc <- "Conditional Inference Tree"

# Determine what type of model to build based on the number of values of the target variable
# Not needed for ctree as it automatically handles the data type

# Define the formula for the model

# TODO 20240930 gjw SHOULDN'T THIS BE FRO `model_template.r`

form <- as.formula(paste(target, "~ ."))

control <- ctree_control(
  MINSPLIT, MINBUCKET, MAXDEPTH
)

# Train a Conditional Inference Tree model using ctree.

model_ctree <- ctree(
  formula   = form,
  data      = trds,
  na.action = na.exclude,
  control   = control
)

# Save the model to the TEMPLATE variable `model` and the predicted
# values appropriately.

model <- model_ctree

predicted_tr <- predict(model_ctree, newdata = trds, type = "prob")
predicted_tu <- predict(model_ctree, newdata = tuds, type = "prob")
predicted_te <- predict(model_ctree, newdata = teds, type = "prob")

# Output a textual view of the Conditional Inference Tree model.

print(model_ctree)
summary(model_ctree)
cat("\n")

# Plot the resulting Conditional Inference Tree.

svg("TEMPDIR/model_tree_ctree.svg")
plot(model_ctree, main = paste("Conditional Inference Tree", target))
dev.off()
