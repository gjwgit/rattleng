# Define `pred_ra` and `prob_ra` for a random forest model.
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
# https://survivor.togaware.com/datascience/ for further details.

# 20241220 gjw Save the model to the TEMPLATE variable `model`. This
# will be used below and in the following evaluations as required.

model <- model_randomForest

# 20250105 zy Redefine the model type to update the output of error
# matrix.

mtype <- "randomForest"
mdesc <- "Random Forest"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities for any dataset.

pred_ra <- function(model, data) {
  # Get the class probability matrix: one row per observation.

  prob_matrix <- predict(model, newdata = data, type = "prob")
  
  # For each row, decide which column is higher, or NA if both are NA.
  # 'apply' with MARGIN=1 loops over rows.

  pred_vec <- apply(prob_matrix, 1, function(prob_row) {
    # If both values are NA, return NA.

    if (all(is.na(prob_row))) {
      return(NA)
    } else {
      # Get the index of the column with the highest probability.

      idx_max <- which.max(prob_row)

      # Retrieve the column name associated with that index.

      chosen_class <- names(prob_row)[idx_max]

      # Return the column name (whatever it is).

      return(chosen_class)
    }
  })

  return(pred_vec)
}

prob_ra <- function(model, data) predict(model, newdata=data, type="prob")[,2]
