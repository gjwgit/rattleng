# Define `pred_ra` and `prob_ra` for a nnet model.
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

# Rattle timestamp: <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# 20241220 gjw Save the model to the <TEMPLATE> variable `model`. This
# will be used below and in the following evaluations as required.

model <- model_nn

# 20250105 zy Redefine the model type to update the output of error
# matrix.

mtype <- "nnet"
mdesc <- "Neural NNET"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities for any dataset.

pred_ra <- function(model, data) {
  target_levels <- unique(data[[target]])  # nolint as sourced from 'model_template.R'

  # Get predictions from the model.

  raw_predictions <- predict(model, newdata = data)
  
  # Convert the raw predictions to the desired format.

  formatted_predictions <- ifelse(
    is.na(raw_predictions), 
    NA, 
    ifelse(raw_predictions < 0.5, as.character(target_levels[2]), as.character(target_levels[1]))
  )
  
  # Return the formatted predictions.

  return(formatted_predictions)
}

prob_ra <- function(model, data) {
  # Get predictions from the model.

  raw_predictions <- predict(model, newdata = data)
  
  # Convert to a vector by selecting the first column, preserving NA.

  if (is.matrix(raw_predictions)) {
    result <- raw_predictions[, 1]
  } else {
    result <- raw_predictions
  }
  
  # Return the result as a vector.

  return(result)
}
