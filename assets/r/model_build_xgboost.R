# Build an XGBoost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-10-13 17:22:35 +1100 Graham Williams>
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

library(xgboost)        # For XGBoost model.
library(rattle)         # Provides a convenient wrapper for xgboost.
library(Ckmeans.1d.dp)  # For ggplot
library(data.table)     # Display data as a nicely formatted table

# Define model type and description.

mtype <- "xgboost"
mdesc <- "Extreme Gradient Boosting (XGBoost)"

# Extract features and target variable.

tds <- ds[tr, vars]

model_xgb <- rattle::xgboost(form,
                     data              = tds, 
                     max_depth         = BOOST_MAX_DEPTH,     # Maximum depth of a tree
                     eta               = BOOST_LEARNING_RATE, # Learning rate
                     nthread           = BOOST_THREADS,       # Set the number of threads
                     num_parallel_tree = 1, 
                     nrounds           = BOOST_ITERATIONS,
                     metrics           = 'error',
                     objective         = BOOST_OBJECTIVE, )

# Print the summary of the trained model.

print(model_xgb)
summary(model_xgb)

# Feature Importance Plot.

svg("TEMPDIR/model_xgb_importance.svg")
importance_matrix <- xgb.importance(model = model_xgb)

# Create a ggplot-based importance plot.

importance_plot <- xgb.ggplot.importance(importance_matrix, measure = "Gain", rel_to_first = FALSE)

# Convert the importance_matrix to a data.table.

importance_dt <- as.data.table(importance_matrix)

# Format the output to match your desired style.

print(importance_dt, row.names = FALSE)

# Add value labels to the bars using geom_text().

importance_plot <- importance_plot +
  geom_text(aes(label = round(Importance, 4), y = Importance), 
            hjust = -0.2, 
            size = 3,)

# Increase plot limits to make space for the labels.

importance_plot <- importance_plot + expand_limits(y = max(importance_matrix$Importance) * 1.2)

# Display the plot.

print(importance_plot)

dev.off()

# Prepare probabilities for predictions.

predicted <- predict(model_xgb, 
                     newdata    = tuds,)
  
actual <- as.character(tuds[[target]])
  
# Create numeric risks vector.

risks <- rep(1, length(actual))

# Get unique levels of predicted.

levels_predicted <- unique(predicted)
levels_actual <- unique(actual)
actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(predicted))

# Replace NA or NaN in predicted_numeric.

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Replace NA or NaN in actual_numeric.

actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Replace NA or NaN in risks.

risks <- ifelse(is.na(risks) | is.nan(risks), 1, risks)

# Step 1: Ensure predicted_numeric has valid probabilities (0 to 1).

predicted_numeric <- ifelse(predicted_numeric < 0 | is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Step 2: Ensure actual_numeric is binary (0 or 1).

actual_numeric <- ifelse(actual_numeric < 0 | actual_numeric > 1 | is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Step 3: Ensure risks are valid and non-negative.

risks <- ifelse(is.na(risks) | is.nan(risks), 1, risks)

# Step 4: Ensure all vectors have the same length.

min_length <- min(length(predicted_numeric), length(actual_numeric), length(risks))
predicted_numeric <- predicted_numeric[1:min_length]
actual_numeric <- actual_numeric[1:min_length]
risks <- risks[1:min_length]

# Step 5: Ensure predicted_numeric has valid probabilities (0 to 1).

predicted_numeric <- pmin(pmax(predicted_numeric, 0), 1)

# Generate risk chart.

svg("TEMPDIR/model_xgboost_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks) +
  labs(title = "Risk Chart - Tuning Dataset") +
  theme(plot.title = element_text(size=14))
dev.off()
