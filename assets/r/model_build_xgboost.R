# Rattle Scripts: From dataset ds build an XGBoost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-10-01 09:09:44 +1000 Graham Williams>
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
# FOR MORE DETAILS.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Zheyuan Xu

# Load required libraries.

if (!requireNamespace("caret", quietly = TRUE)) {
  install.packages("caret")
}

if (!requireNamespace("xgboost", quietly = TRUE)) {
  install.packages("xgboost")
}

if (!requireNamespace("Matrix", quietly = TRUE)) {
  install.packages("Matrix")
}

if (!requireNamespace("Ckmeans.1d.dp", quietly = TRUE)) {
  install.packages("Ckmeans.1d.dp")
}

library(caret)  # For dummy variable encoding
library(xgboost) # For XGBoost model
library(Matrix)  # For handling matrix operations if needed
library(Ckmeans.1d.dp) # For ggplot

# Define model type and description.

mtype <- "xgboost"
mdesc <- "Extreme Gradient Boosting (XGBoost)"

# Extract features and target variable.

train_data <- ds[tr, vars]
train_labels <- unlist(ds[tr, target])  # Use `unlist()` to ensure train_labels is not a list.
train_labels <- as.numeric(train_labels)  # Convert to numeric.

# Convert categorical features in train_data to dummy variables.
# Option 1: Using model.matrix to one-hot encode categorical variables.

train_data <- model.matrix(~ . - 1, data = train_data)  # -1 removes the intercept column

# Option 2: If `model.matrix()` still leaves character data, manually convert it.

char_cols <- sapply(train_data, is.character)

# Convert character columns to factors and then to numeric.

if (any(char_cols)) {
  for (col in names(train_data)[char_cols]) {
    train_data[[col]] <- as.numeric(factor(train_data[[col]]))
  }
}

# Convert to numeric matrix format for XGBoost.

train_data <- as.matrix(train_data)

# Remove any rows with NA values to avoid mismatches.

combined <- cbind(train_data, train_labels)
combined <- na.omit(combined)

# Split back into train_data and train_labels.

train_data <- combined[, -ncol(combined)]
train_labels <- combined[, ncol(combined)]

# Convert back to appropriate formats.

train_data <- as.matrix(train_data)
train_labels <- as.numeric(train_labels)

# Construct DMatrix for training.

dtrain <- xgb.DMatrix(data = train_data, label = train_labels)

# Set additional options.

nrounds <- 100             

# Set parameters for the XGBoost model.

params <- list(
  booster          = "gbtree",  # Use tree-based booster
  objective        = "reg:squarederror", # Change this to "binary:logistic" for classification
  eta              = 0.1,       # Learning rate
  max_depth        = 6,         # Maximum depth of a tree
  subsample        = 0.8,       # Fraction of observations to be randomly sampled for each tree
  colsample_bytree = 0.8        # Fraction of features to be randomly sampled for each tree
)

# Train the XGBoost model.

model_xgb <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = nrounds,
  verbose = 1                # Set to 1 to see the training progress
)

# Print the summary of the trained model.

print(model_xgb)
summary(model_xgb)

# Feature Importance Plot.

svg("TEMPDIR/model_xgb_importance.svg")
importance_matrix <- xgb.importance(feature_names = colnames(train_data), model = model_xgb)
xgb.ggplot.importance(importance_matrix, main = "Feature Importance", cex = 0.7)
dev.off()
