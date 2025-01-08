# Setup the model template variables for descriptive and predictive models.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-12-25 17:20:41 +1100 Graham Williams>
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
# Run this script after the variable `ds` (dataset) and other data
# template variables have been defined as in `data_template.R`. This
# script will initialise the model template variables including
# performing any partitioning.
#
# References:
#
# @williams:2017:essentials Chapter 7.
#
# https://survivor.togaware.com/datascience/model-template.html

# Load required packages from the local library into the R session.

library(stringi)      # The string concat operator %s+%.

# Record basic variable roles for the templates.

ignore <- c(risk, id, IGNORE_VARS)
vars   <- setdiff(vars, ignore)
inputs <- setdiff(vars, target)

# Generate the formula to be used for predictive modelling which is
# available when a TARGET variable is identified.

if (!is.null(target)) {
  form <- formula(target %s+% " ~ .")

  # Identify a subset of the full dataset that has values for the target
  # variable, removing those rows that do not have a target. For
  # predictive modelling we will only use data that has a target value.
  # This will be refered to as the TARGET COMPLETE dataset (tcds).

  tcds <- ds[!is.na(ds[[target]]),]

} else {

  form <- formula("~ .")

  # If not TARGET variable is identified then we still want to start
  # with a `tcds` for processing.

  tcds <- ds

}

print(form)

# Update the number of `obs` which is needed for the partitioning.

tcnobs <- nrow(tcds)

if (SPLIT_DATASET) {

  # Split the dataset into train, tune, and test, recording the indicies
  # of the observations to be associated with each dataset. If the
  # dataset is not to be partitioned, simply have the train, tune and
  # test datasets as the whole dataset.

  # To get the same model each time we partitin the dataset the same
  # way each time based on a fixed seed that the user can override to
  # explore the impact of different dataset paritioning on the
  # resulting model.

  # TODO 20241202 gjw REPLACE THE FIXED 42 WITH A SETTINGS VALUE FOR THE SEED.

  # TODO 20241202 gjw ADD PROVIDER FOR RANDOM_PARTITION TO RANDOMISE EACH TIME.

  # TODO 20241202 gjw MAYBE IF RANDOM_SEED IS EMPTY WE RANDOMISE EACH TIME HERE.

  if (! RANDOM_PARTITION) {
    set.seed(RANDOM_SEED)
  }

  # Specify the three way split for the dataset: TRAINING (tr) and
  # TUNING (tu) and TESTING (te).

  split <- c(DATA_SPLIT_TR_TU_TE)

  tr <- tcnobs %>% sample(split[1]*tcnobs)
  tu <- tcnobs %>% seq_len() %>% setdiff(tr) %>% sample(split[2]*tcnobs)
  te <- tcnobs %>% seq_len() %>% setdiff(tr) %>% setdiff(tu)

} else {

  # If the user has decided not to partition the data we will build
  # the model and tune/test the model on the same dataset. This is not
  # good practice as the tuning and testing will deliver very
  # optimistic estimates of the model performance.

  tr <- tu <- te <- seq_len(tcnobs)
}

# Note the actual values of the TARGET variable and the RISK variable
# for use in model training and evaluation later on.

if (!is.null(target)) {
  actual_tr <- tcds %>% slice(tr) %>% pull(target)
  actual_tu <- tcds %>% slice(tu) %>% pull(target)
  actual_te <- tcds %>% slice(te) %>% pull(target)
}

if (!is.null(risk)) {
  risk_tr <- tcds %>% slice(tr) %>% pull(risk)
  risk_tu <- tcds %>% slice(tu) %>% pull(risk)
  risk_te <- tcds %>% slice(te) %>% pull(risk)
}

# Retain only the columns that we need for the predictive modelling.

trds <- tcds[tr, setdiff(vars, ignore)]
tuds <- tcds[tu, setdiff(vars, ignore)]
teds <- tcds[te, setdiff(vars, ignore)]

# Check if the target variable exists and create `actual_tc`.

if (!is.null(target)) {
  # Retrieve the actual values for the full dataset and remove `NA`.

  actual_tc <- tcds %>%
    pull(target) %>%
    as.character()

  # Convert to numeric (binary if applicable).

  levels_actual <- unique(actual_tc)
  actual_numeric_tc <- ifelse(actual_tc == levels_actual[1], 0, 1)
} else {
  # If no target, set `actual_tc` to NULL.

  actual_tc <- NULL
  actual_numeric_tc <- NULL
}

# Check if the risk variable exists and create `risk_tc`.

if (!is.null(risk)) {
  # Retrieve the risk values for the full dataset.

  risk_tc <- tcds %>%
    pull(risk) %>%
    as.numeric()  # Ensure it's numeric.

  # Handle NA values by replacing them with a default value (e.g., 0).

  risk_tc <- ifelse(is.na(risk_tc) | is.nan(risk_tc), 0, risk_tc)
} else {
  # If no risk, set `risk_tc` to NULL.

  risk_tc <- NULL
}

####################################
# TODO 20241202 gjw REVIEW ALL OF THE FOLLOWING - WHY HERE OR WHY NEEDED

# Identify predictor variables (excluding the target variable).

# TODO 20241202 gjw WHY IS THIS NEEDED - USE INPUTS

# predictor_vars <- setdiff(vars, target)

# Identify categoric and numeric input variables.

cat_vars <- names(Filter(function(col) is.factor(col) || is.character(col), ds[inputs]))
num_vars <- setdiff(inputs, cat_vars)

# TODO 20241112 gjw FIX THIS CLUMSY NAME

ignore_categoric_vars <- c(num_vars, target)

# TODO 20241202 gjw THIS SEEMS OUT OF PLACE HERE

neural_ignore_categoric <- NEURAL_IGNORE_CATEGORIC

# Create numeric risks vector.

# TODO 20241202 gjw WHAT IS THIS USED FOR? CAN NOW BE REMOVED?

risks <- as.character(risk_tu)
risks <- risks[!is.na(risks)]
risks <- as.numeric(risks)

# Create numeric actual vector.

# TODO 20241202 gjw WHAT IS THIS USED FOR? CAN NOW BE REMOVED?

actual <- as.character(actual_tu)
actual <- actual[!is.na(actual)]
levels_actual <- unique(actual)
actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# The `generate_predictions` function simulates a prediction process, generating class labels
# based on randomly created probability matrices for a given set of observations.

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

# A data preprocessing function for prediction tasks.
# Handles prediction and actual value preprocessing.
# Converts inputs to numeric format. Handles NA and NaN values.
# Aligns input vectors to same length. Uses minimum length to truncate vectors.

prepare_predictions <- function(pr_tu, actual, risks) {
  # Get unique levels of predictions and actual values.

  levels_predicted <- unique(pr_tu)

  # Convert predictions to numeric, handling NA or invalid values.

  predicted_numeric <- ifelse(pr_tu == levels_predicted[1], 0, 1)
  predicted_numeric <- suppressWarnings(as.numeric(pr_tu))
  predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

  # Align vectors to the same length by using the minimum length.

  min_length <- min(length(predicted_numeric), length(actual), length(risks))
  predicted_numeric <- predicted_numeric[1:min_length]
  actual_numeric <- as.numeric(as.factor(actual))[1:min_length] - 1
  actual_numeric <- ifelse(actual_numeric < 0, 0, actual_numeric) # Ensure no negative values.
  risks <- risks[1:min_length]

  # Replace remaining NA or NaN values in `predicted_numeric` with a default value.

  predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

  # Replace NA or NaN in actual_numeric with a default value (e.g., 0).

  actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

  # Return the processed vectors as a list.

  list(
    predicted_numeric = predicted_numeric,
    actual_numeric = actual_numeric,
    risks = risks
  )
}
