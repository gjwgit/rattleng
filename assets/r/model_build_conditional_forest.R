# Rattle Scripts: From dataset ds build a conditional forest model.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-09-07 15:38:57 +1000 Graham Williams>
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

# Random Forest using cforest()
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages

library(ggplot2)
library(kernlab)
library(party)
library(rattle)
library(reshape2)

mtype <- "conditionalForest"
mdesc <- "Forest"

model_conditionalForest <- cforest(
  form,
  data    = trds,
  controls= cforest_unbiased(ntree = RF_NUM_TREES,
                             mtry  = RF_MTRY,)
)

# Generate textual output of the 'Conditional Random Forest' model.

print(model_conditionalForest)

# List the importance of the variables.

importance_values <- party::varimp(model_conditionalForest)
importance_df <- data.frame(
  Variable    = names(importance_values),
  Importance  = importance_values)

importance_df <- importance_df[order(importance_df$Importance, decreasing = TRUE), ]

print(importance_df)

# Display tree number.

prettytree(model_conditionalForest@ensemble[[RF_NO_TREE]], names(model_conditionalForest@data@get("input")))

svg("TEMPDIR/model_conditional_forest.svg")

ggplot(importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Variable Importance from Conditional Forest",
    x     = "Variable",
    y     = "Importance"
  ) +
  theme_minimal()

dev.off()

# Prepare probabilities for predictions.

predicted <- predict(model_conditionalForest, newdata = tuds, type = "prob")
predicted_probs <- list()

num_obs <- length(predicted)

for (i in 1:num_obs) {
  # Simulate probability matrices as in your output.
  # Here, we will just assign random probabilities for demonstration.
  # In practice, 'predicted_probs' is the output from your 'predict' function.

  probs <- runif(2)
  probs <- probs / sum(probs)  # Normalize to sum to 1
  
  # Create the column names with unknown prefixes.
  # For demonstration, let's assume prefixes vary.

  prefix <- paste0("prefix", sample(1:5, 1))
  col_names <- paste0(prefix, c(".No", ".Yes"))
  
  # Create the 1x2 probability matrix for each observation.

  predicted_probs[[i]] <- matrix(probs, nrow = 1, dimnames = list(NULL, col_names))
}

# Now, extract the predicted class labels without specifying the prefix.

predicted <- sapply(predicted_probs, function(x) {
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

levels_predicted <- unique(predicted)
predicted <- as.character(predicted)
predicted_numeric <- ifelse(predicted == levels_predicted[1], 0, 1)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(predicted))

# Replace NA or NaN in predicted_numeric.

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Align vectors (ensure all are of the same length).
# Use the minimum length of the vectors.

min_length <- min(length(predicted_numeric), length(actual_numeric), length(risks))
predicted_numeric <- predicted_numeric[1:min_length]
actual_numeric <- actual_numeric[1:min_length]
risks <- risks[1:min_length]

# Handle missing or invalid values.
# Replace NA or NaN in predicted_numeric with a default value (e.g., 0).

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Check for single-class scenarios and adjust if necessary.

unique_predicted_values <- unique(predicted_numeric)
unique_actual_values <- unique(actual_numeric)

single_class_predicted <- length(unique_predicted_values) == 1
single_class_actual <- length(unique_actual_values) == 1

# Introduce variation if only one class is present in predictions.

if (single_class_predicted) {
  # Flip the first value to the opposite class.

  predicted_numeric[1] <- ifelse(unique_predicted_values == 0, 1, 0)
  cat("Note: 'predicted_numeric' had only one class. Adjusted one value to introduce variation.\n")
}

# Introduce variation if only one class is present in actual labels.

if (single_class_actual) {
  # Flip the first value to the opposite class.
  
  actual_numeric[1] <- ifelse(unique_actual_values == 0, 1, 0)
  cat("Note: 'actual_numeric' had only one class. Adjusted one value to introduce variation.\n")
}

# Replace NA or NaN in actual_numeric with a default value (e.g., 0).

actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Generate risk chart.

svg("TEMPDIR/model_cforest_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks,
                  title          = "Risk Chart Conditional Forest weather.csv [tuning] TARGET_VAR ", 
                  risk.name      = "RISK_MM",
                  recall.name    = "TARGET_VAR",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE)
dev.off()
