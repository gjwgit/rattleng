# From dataset `trds` build a `neuralnet()` neural model.
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 08:57:45 +1100 Graham Williams>
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
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(neuralnet)
library(caret)
library(NeuralNetTools)  # For neural network plotting
library(rattle)

# Define the model type and description for file paths and titles.

mtype <- "neuralnet"
mdesc <- "Neural Neuralnet"

# training_ds is set to replace trds in handling situations of
# Ignore Categoric and Not Ignore Categoric.

# Subset the training data.

if (neural_ignore_categoric) {

  # Only use numeric variables when ignoring categoric.

  vars_to_use <- num_vars
  training_ds <- ds[tr, c(num_vars, target)]

} else {

  vars_to_use <- vars
  training_ds <- trds

}

# neuralnet() do not handle missing data automatically.
# Remove rows with missing values in predictors or target variable.

training_ds <- training_ds[complete.cases(training_ds),]

# Initialize empty data frame for predictors.

predictors_combined <- data.frame()

# Handle numeric variables scaling.
# Neural networks often perform better when all input features are on a similar scale.

if (length(num_vars) > 0) {
  predictors_numeric_scaled <- scale(training_ds[num_vars])
  predictors_combined <- as.data.frame(predictors_numeric_scaled)
}

# Handle categoric variables only if not ignoring them.

if (!neural_ignore_categoric && length(cat_vars) > 0) {
  # Create dummy variables for categoric predictors.

  dmy_predictors <- dummyVars(~ ., data = training_ds[cat_vars])
  
  # Use the dummyVars model to transform the original categorical predictors
  # into dummy/indicator columns.

  predictors_categoric <- as.data.frame(predict(dmy_predictors, newdata = training_ds[cat_vars]))

  # Combine with numeric predictors if they exist.

  predictors_combined <- if (ncol(predictors_combined) > 0) {
    cbind(predictors_combined, predictors_categoric)
  } else {
    predictors_categoric
  }
}

# Handle Target Variable Encoding.

target_levels <- unique(training_ds[[target]])
target_levels <- target_levels[!is.na(target_levels)]  # Remove NA if present

if (length(target_levels) == 2) {
  # Binary Classification
  # Map target variable to 0 and 1.

  training_ds$target_num <- ifelse(training_ds[[target]] == target_levels[1], 0, 1)
  
  # Combine predictors and target.

  ds_final <- cbind(predictors_combined, target_num = training_ds$target_num)
  
  # Create formula.

  predictor_vars <- names(predictors_combined)

  # Putting target_num to the left of ~ tells the model
  # that target_num is the variable the neural network should learn to predict.

  formula_nn <- as.formula(paste('target_num ~', paste(predictor_vars, collapse = ' + ')))
  
  # Train neural network.

  model_neuralnet <- neuralnet(
    formula       = formula_nn,
    data          = ds_final,
    hidden        = NEURAL_HIDDEN_LAYERS,
    act.fct       = NEURAL_ACT_FCT,
    err.fct       = NEURAL_ERROR_FCT,
    linear.output = FALSE,
    threshold     = NEURAL_THRESHOLD,
    stepmax       = NEURAL_STEP_MAX,
  )
} else {
  # Multiclass Classification
  # One-Hot Encode the Target Variable.

  dmy_target <- dummyVars(~ ., data = training_ds[target])
  target_onehot <- as.data.frame(predict(dmy_target, newdata = training_ds[target]))
  
  # Combine predictors and target.

  ds_final <- cbind(predictors_combined, target_onehot)
  
  # Create formula.

  predictor_vars <- names(predictors_combined)
  target_vars <- names(target_onehot)
  
  # Build a formula where the target side (left of ~) may include multiple columns 
  # because one-hot encoding creates a column for each category/class (e.g., ClassA, ClassB, ...).

  formula_nn     <- as.formula(paste(
    paste(target_vars, collapse = ' + '),
    '~',
    paste(predictor_vars, collapse = ' + ')
  ))
  
  # Train neural network.

  model_neuralnet <- neuralnet(
    formula       = formula_nn,
    data          = ds_final,
    hidden        = NEURAL_HIDDEN_LAYERS,
    act.fct       = NEURAL_ACT_FCT,
    err.fct       = NEURAL_ERROR_FCT,
    linear.output = FALSE,
    threshold     = NEURAL_THRESHOLD,
    stepmax       = NEURAL_STEP_MAX,
  )
}

# Generate a textual view of the Neural Network model.

print(model_neuralnet)
summary(model_neuralnet)

# Save the plot as an SVG file.

svg("TEMPDIR/model_neuralnet.svg")
NeuralNetTools::plotnet(model_neuralnet,
                        cex_val    = 0.5,
                        circle_cex = 2,
                        rel_rsc    = c(1, 3),
                        pos_col    = "orange",
                        neg_col    = "grey",
                        node_labs  = TRUE)
dev.off()
