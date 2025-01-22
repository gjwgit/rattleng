# Define `pred_ra` and `prob_ra` for a conditional forest model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-01-23 08:53:15 +1100 Graham Williams>
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

# Rattle timestamp: <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/ for further details.

# The `generate_predictions` function simulates a prediction process,
# generating class labels based on randomly created probability
# matrices for a given set of observations. 20250123 gjw This seems to
# only be used by cforest. If that is the case then it should be moved
# there.


generate_predictions <- function(predicted_var) {
  # 1) Handle the case where 'predicted_var' is a named numeric vector.
  #    - If it's numeric and has names, we rename those elements sequentially.
  #    - Then immediately return the vector as-is.

  if (is.numeric(predicted_var) && !is.null(names(predicted_var))) {
    # Rename the elements '1', '2', '3', ... instead of whatever they had before.

    names(predicted_var) <- seq_along(predicted_var)
    return(predicted_var)
  }

  # 2) Handle the case where 'predicted_var' is already a list of matrices
  #    (or at least something indexable like matrices).
  #    - We assume each element in the list has at least 2 columns, and we grab
  #      the value in row 1, column 2 from each element (x[1, 2]).

  if (is.list(predicted_var)) {
    # Extract the second column from row 1 in each element of 'predicted_var'.

    result <- sapply(predicted_var, function(x) x[1, 2])
    # Rename the result elements '1', '2', '3', ...

    names(result) <- seq_along(result)
    return(result)
  }

  # 3) If 'predicted_var' is neither a named numeric vector nor a list:
  #    - We assume it's some other data structure (e.g., a vector of observations).
  #    - We'll generate random probabilities (1×2) for each observation, normalize them,
  #      then extract the second probability for each.

  # Initialize a list to hold the simulated probability matrices.

  predicted_probs <- list()

  # Number of observations is the length of 'predicted_var'.

  num_obs <- length(predicted_var)

  # For each observation, generate random probabilities (2 values),
  # normalize them to sum to 1, then store as a 1×2 matrix.

  for (i in 1:num_obs) {
    probs <- runif(2)          # Generate 2 random probabilities
    probs <- probs / sum(probs)  # Normalize them so they sum to 1
    predicted_probs[[i]] <- matrix(probs, nrow = 1)  # Store as a 1×2 matrix
  }

  # Extract the second probability from each 1×2 matrix (row=1, col=2).

  result <- sapply(predicted_probs, function(x) x[1, 2])

  # Rename the result elements '1', '2', '3', ...

  names(result) <- seq_along(result)

  # Return the vector of probabilities.

  return(result)
}

# 20241220 gjw Save the model to the <TEMPLATE> variable `model`. This
# will be used below and in the following evaluations as required.

model <- model_conditionalForest

# 20250105 zy Redefine the model type to update the output of error
# matrix.

mtype <- "cforest"
mdesc <- "Random Forest"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities for any dataset.

pred_ra <- function(model, data) predict(model, newdata=data, )

prob_ra <- function(model, data) {
  prob_matrix <- predict(model, newdata=data, type="prob")
  generate_predictions(prob_matrix) # nolint as sourced from 'model_template.R'
}
