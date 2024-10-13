# Build a neuralnet() network.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-10-13 20:15:24 +1100 Graham Williams>
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

library(neuralnet)
library(caret)
library(NeuralNetTools)  # For neural network plotting

# Define the target variable.

target_variable <- target

# Subset the training data.

tds <- ds[tr, vars]

# Remove rows with missing values in predictors or target variable.

tds <- tds[complete.cases(tds), ]

# Identify predictor variables (excluding the target variable).

predictor_vars <- setdiff(vars, target_variable)

# Identify categorical and numerical predictor variables.

categorical_vars <- names(Filter(function(col) is.factor(col) || is.character(col), tds[predictor_vars]))
numerical_vars <- setdiff(predictor_vars, categorical_vars)

# One-Hot Encode Categorical Predictor Variables.

if (length(categorical_vars) > 0) {
  # Create dummy variables for categorical predictors.

  dmy_predictors <- dummyVars(~ ., data = tds[categorical_vars])
  predictors_onehot_categorical <- as.data.frame(predict(dmy_predictors, newdata = tds[categorical_vars]))
} else {
  predictors_onehot_categorical <- data.frame()
}

# Scale Numerical Predictor Variables.

if (length(numerical_vars) > 0) {
  predictors_numeric_scaled <- scale(tds[numerical_vars])
  predictors_numeric_scaled <- as.data.frame(predictors_numeric_scaled)
} else {
  predictors_numeric_scaled <- data.frame()
}

# Combine all predictors.

predictors_onehot <- cbind(predictors_numeric_scaled, predictors_onehot_categorical)

# Handle Target Variable Encoding.
# Check if the target variable is binary or multiclass.

target_levels <- unique(tds[[target_variable]])
target_levels <- target_levels[!is.na(target_levels)]  # Remove NA if present

if (length(target_levels) == 2) {
  # Binary Classification

  # Map target variable to 0 and 1.

  tds$target_num <- ifelse(tds[[target_variable]] == target_levels[1], 0, 1)

  # Combine predictors and target.

  ds_onehot <- cbind(predictors_onehot, target_num = tds$target_num)

  # Create formula.

  predictor_vars_onehot <- names(predictors_onehot)
  formula_nn <- as.formula(paste('target_num ~', paste(predictor_vars_onehot, collapse = ' + ')))

  # Train neural network.

  model_neuralnet <- neuralnet(
    formula = formula_nn,
    data = ds_onehot,
    hidden = HIDDEN_NEURONS,
    act.fct = "logistic",
    err.fct = "ce",
    linear.output = FALSE,
    threshold = 0.01
  )

} else {
  # Multiclass Classification

  # One-Hot Encode the Target Variable.

  dmy_target <- dummyVars(~ ., data = tds[target_variable])
  target_onehot <- as.data.frame(predict(dmy_target, newdata = tds[target_variable]))

  # Combine predictors and target.

  ds_onehot <- cbind(predictors_onehot, target_onehot)

  # Create formula.

  predictor_vars_onehot <- names(predictors_onehot)
  target_vars_onehot <- names(target_onehot)
  formula_nn <- as.formula(paste(
    paste(target_vars_onehot, collapse = ' + '),
    '~',
    paste(predictor_vars_onehot, collapse = ' + ')
  ))

  # Train neural network.

  model_neuralnet <- neuralnet(
    formula = formula_nn,
    data = ds_onehot,
    hidden = HIDDEN_NEURONS,
    act.fct = "logistic",
    err.fct = "sse",
    linear.output = FALSE,
    threshold = 0.01
  )
}

# Generate a textual view of the Neural Network model.

print(model_neuralnet)
summary(model_neuralnet)

# Save the plot as an SVG file.

svg("TEMPDIR/model_neuralnet.svg")
NeuralNetTools::plotnet(model_neuralnet,
                        cex_val=0.5,
                        circle_cex=2,
                        rel_rsc = c(1, 3),
                        pos_col="orange",
                        neg_col="grey",
                        node_labs=TRUE)
dev.off()
