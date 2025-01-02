# Use `rattle::errorMatrix()` to generate error matrix evaluation.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2024-12-20 20:46:39 +1100 Graham Williams>
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
# Author: Zheyuan Xu, Graham Williams

# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

## #########################################################################
## #########################################################################
## #########################################################################
## 20241220 gjw DO NOT MODIFY THIS FILE WITHOUT DISCUSSION
## #########################################################################
## #########################################################################
## #########################################################################

# Load required packages from the local library into the R session.

library(rattle)       # Generate an error matrix.

########################################################################

# Identify positions where either vector has NA. 20241220 gjw Whcih
# models needed this and can we fix that in the evaluate_model part?
# Or is it best here?

#na_positions <- is.na(error_matrix_target) | is.na(error_matrix_predic)

# Remove NA positions from both vectors.

#error_matrix_predic <- error_matrix_predic[!na_positions]
#error_matrix_target <- error_matrix_target[!na_positions]


# Setting `count=TRUE` in `errorMatrix()` ensures the matrix
# represents raw counts of predictions rather than the proportions.
##
## 20241220 gjw The r/source.dart was creating a new variable for each
## error matrix. Probably for some checking in dart for the
## differently generated error matrices. Is there a better way to do
## this? E.g., look for `mdodel <- model_rpart` in the stdout and then
## find the first `print(em_count)` for the RPart error matrix, etc.

em_count <- rattle::errorMatrix(actual, predicted, count=TRUE)
print(em_count)

# Generate a confusion matrix with proportions (relative frequencies)
# rather than counts.

em_prop <- rattle::errorMatrix(actual, predicted)
print(em_prop)
