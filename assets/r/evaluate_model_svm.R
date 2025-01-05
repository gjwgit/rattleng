# Generate template variables for evaluating a svm model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-12-25 17:17:19 +1100 Graham Williams>
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
# Author: Zheyuan Xu

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
## #########################################################################
## 20241220 gjw DO NOT MODIFY THIS FILE WITHOUT DISCUSSION

model <- svm_model

# 20250105 zy Redefine the model type to update the output of error matrix.

mtype <- "svm"
mdesc <- "Support Vector Machine"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities for any dataset.

pred_ra <- function(model, data) {
  # Get the probability matrix from the model.

  prob_matrix <- predict(model, newdata = data, type = "prob")

  # Identify, for each row, which column has the highest probability.

  idx_max <- max.col(prob_matrix, ties.method = "first")

  # Convert those column indices into class labels.

  colnames(prob_matrix)[idx_max]
}
prob_ra <- function(model, data) predict(model, newdata = data, type = "prob")[,2]
