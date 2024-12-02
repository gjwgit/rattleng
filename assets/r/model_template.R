# Rattle Scripts: Setup the model template variables.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2024-12-02 09:40:03 +1100 Graham Williams>
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

# Rattle timestamp: TIMESTAMP
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

library(stringi)      # The string concat operator %s+%.

ignore <- c(risk, id, IGNORE_VARS)
vars   <- setdiff(vars, ignore)
inputs <- setdiff(vars, target)

# Generate the formula to be used for predictive modelling.

form   <- formula(target %s+% " ~ .")

print(form)

# Identify a subset of the full dataset that has values for the target
# variable, removing those rows that do not have a target. For
# predictive modelling we will only use data that has a target value.
# This will be refered to as the TARGET COMPLETE dataset (tcds).

tcds <- ds[!is.na(ds[[target]]),]

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

actual_tr <- tcds %>% slice(tr) %>% pull(target)
actual_tu <- tcds %>% slice(tu) %>% pull(target)
actual_te <- tcds %>% slice(te) %>% pull(target)
  
if (!is.null(risk))
{
  risk_tr <- tcds %>% slice(tr) %>% pull(risk)
  risk_tu <- tcds %>% slice(tu) %>% pull(risk)
  risk_te <- tcds %>% slice(te) %>% pull(risk)
}

# Retain only the columns that we need for the predictive modelling.

trds <- tcds[tr, setdiff(vars, ignore)]
tuds <- tcds[tu, setdiff(vars, ignore)]
teds <- tcds[te, setdiff(vars, ignore)]

########################################################################
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
  predicted_probs <- list()
  
  num_obs <- length(predicted_var)
  
  for (i in 1:num_obs) {
    # Simulate probability matrices as in your output.
    # Here, we will just assign random probabilities for demonstration.
    # In practice, 'predicted_probs' is the output from your 'predict' function.
    
    probs <- runif(2)
    probs <- probs / sum(probs)  # Normalize to sum to 1.
    
    # Create the column names with unknown prefixes.
    # For demonstration, let's assume prefixes vary.
    
    prefix <- paste0("prefix", sample(1:5, 1))
    col_names <- paste0(prefix, c(".No", ".Yes"))
    
    # Create the 1x2 probability matrix for each observation.

    predicted_probs[[i]] <- matrix(probs, nrow = 1, dimnames = list(NULL, col_names))
  }
  
  # Extract the predicted class labels without specifying the prefix.

  predicted_var <- sapply(predicted_probs, function(x) {
    # 'x' is a 1xN matrix for one observation.
    # Find the index of the maximum probability.
    
    idx_max <- which.max(x[1, ])

    # Retrieve the corresponding class label with prefix.
    
    label_with_prefix <- colnames(x)[idx_max]
    
    # Extract the actual class label by removing everything up to the last dot.

    label_clean <- sub('.*\\.', '', label_with_prefix)
    return(label_clean)
  })
  
  # Get unique levels of predicted.
  
  levels_predicted <- unique(predicted_var)
  predicted_var <- as.character(predicted_var)
  predicted_numeric <- ifelse(predicted_var == levels_predicted[1], 0, 1)
  return(predicted_numeric)
}
