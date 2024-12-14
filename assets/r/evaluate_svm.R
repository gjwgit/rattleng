# Generate error matrix model svm.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-11-30 21:41:15 +1100 Graham Williams>
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
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

library(kernlab)
library(rattle)

error_matrix_predic <- predict(svm_model, newdata = trds, type = "probabilities")

# Convert to a list of labels based on maximum values.

error_matrix_predic <- apply(error_matrix_predic, 1, function(row) {
  if (any(is.na(row))) {
      return(NULL)
  }
  
  # Identify the column with the maximum value.

  max_label <- names(row)[which.max(row)]
  return(max_label)
})

# Remove NULL entries and convert to a simple character vector.

error_matrix_predic <- unlist(error_matrix_predic, use.names = FALSE)

# Find the lengths of the two objects.

len_trds_target <- length(trds[[target]])
len_error_matrix_predic <- length(error_matrix_predic)

# Determine the minimum length.

min_length <- min(len_trds_target, len_error_matrix_predic)

# Subset trds[[target]] to match the minimum length.

svm_target <- trds[[target]][seq_len(min_length)]

# Ensure svm_target has the same length as the rows in error_matrix_predic.

if (length(error_matrix_predic) > min_length) {
  error_matrix_predic <- error_matrix_predic[seq_len(min_length), , drop = FALSE]
}

error_matrix_target <- svm_target
