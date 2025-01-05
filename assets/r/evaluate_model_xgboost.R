# Define `pred_ra` and `prob_ra` for a xgboost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-01-02 11:36:19 +1100 Graham Williams>
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

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/ for further details.

model <- model_xgb

# 20250105 zy Redefine the model type to update the output of error
# matrix.

mtype <- "xgboost"
mdesc <- "Extreme Boost"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities for any dataset.

pred_ra <- function(model, data) {
  # Retrieve the vector of possible target levels from the data.

  target_levels <- unique(data[[target]])  # nolint as sourced from 'model_template.R'
  
  # Get raw numeric probabilities (assuming the model returns a single column
  # or you've already extracted the relevant column.

  prob_vec <- predict(model, newdata=data, type="prob")

  # Map probabilities to factor levels.
  # - If the probability is NA, set the label to NA.
  # - If the probability > 0.5, pick target_levels[2].
  # - Otherwise, pick target_levels[1].
  # We immediately convert to character so the ifelse() doesn't
  # accidentally coerce things back to numeric.

  mapped_values_char <- ifelse(
    is.na(prob_vec),
    NA_character_,
    ifelse(prob_vec > 0.5, 
           as.character(target_levels[2]), 
           as.character(target_levels[1]))
  )

  # Convert the character vector to a factor with the same levels as 'target_levels'.
  # This ensures the output is not numeric, but a factor with consistent levels.

  mapped_values_factor <- factor(mapped_values_char, levels = target_levels)

  # Return the factor vector.

  return(mapped_values_factor)
}

prob_ra <- function(model, data) predict(model, newdata=data, type="prob")
