# Generate error matrix of model random forest.
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

library(rattle)
library(randomForest)

error_matrix_predic <- predict(model_randomForest, newdata = trds, type = "prob")

target_clean <- trds[[target]][!is.na(error_matrix_predic)]

# Remove all <NA> values from the vector.

target_clean <- target_clean[!is.na(target_clean)]

error_matrix_predic <- apply(error_matrix_predic, 1, function(row) {
  if (any(is.na(row))) {
    return(NULL) # Skip rows with NA
  }
  # Find the column name of the maximum value.

  max_label <- names(row)[which.max(row)]
  return(max_label)
})

# Remove NULL entries from the list.

error_matrix_predic <- error_matrix_predic[!sapply(error_matrix_predic, is.null)]

error_matrix_predic <- unlist(error_matrix_predic, use.names = FALSE)

error_matrix_target <- target_clean
