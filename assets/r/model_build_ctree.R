# From dataset `trds` build a `ctree()` conditional tree.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-01-16 09:25:33 +1100 Graham Williams>
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
##
## 20250116 gjw Choose to use partykit (2015) over the older party
## (2008) package. The partykit package can do much more and is a
## framework for supporting other tree packages including rpart, rweka,
## and pmml. It's ctree is a new and improved reimplementations of
## conditional inference trees. See
## https://cran.r-project.org/web/packages/partykit/partykit.pdf and
## https://cran.r-project.org/web/packages/party/party.pdf.
##
## 20250116 gjw From Leo
##
## The ctree function is available in both the party and partykit
## packages in R. While both packages provide similar functionality for
## conditional inference trees, there are some differences between them.
##
## Party Package: The party package is an older package that provides a
## basic implementation of conditional inference trees. It uses a
## recursive partitioning approach to build trees and provides a simple
## way to visualize and interpret the results.  Partykit Package: The
## partykit package is a more recent package that provides a more
## comprehensive and flexible implementation of conditional inference
## trees. It includes additional features such as support for
## multivariate responses, improved visualization tools, and the ability
## to handle larger datasets. The partykit package also provides a more
## robust and efficient algorithm for building trees, which can handle
## complex interactions and non-linear relationships between variables.
## In terms of the ctree function specifically, the partykit package
## provides a more flexible and customizable implementation. The ctree
## function in partykit allows users to specify a wide range of options,
## including the test statistic, splitting criterion, and pruning
## method. Additionally, the partykit package provides a range of
## visualization tools, including plots of the tree structure, node
## information, and predicted probabilities.
##
## Overall, while both packages provide similar functionality, the
## partykit package is generally considered to be more comprehensive and
## flexible, and is likely to be the better choice for most
## users. However, the party package may still be useful for simple
## applications or for users who are already familiar with its
## functionality.
##
## It’s worth noting that the partykit package is designed to be backward
## compatible with the party package, so users who have existing code
## that uses the party package can easily transition to using the
## partykit package.
##
## In summary, the main differences between the party and partykit
## packages are:
##
## Flexibility: The partykit package provides a more flexible and
## customizable implementation of conditional inference trees.
##
## Visualization: The partykit package provides a range of
## visualization tools, including plots of the tree structure, node
## information, and predicted probabilities.
##
## Robustness: The partykit package provides a more robust and
## efficient algorithm for building trees, which can handle complex
## interactions and non-linear relationships between variables.
##
## Compatibility: The partykit package is designed to be backward
## compatible with the party package, making it easy for users to
## transition to the new package.

library(partykit)     # Conditional decision tree.

# Define the model type and description for file paths and titles

mtype <- "ctree"
mdesc <- "Conditional Inference Tree"

# 20250108 gjw Setup the model build parameters.

control <- partykit::ctree_control(
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
