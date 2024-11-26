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
  data    = tds,
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

predicted <- kernlab::predict(model_conditionalForest, 
                              newdata = tuds,
                              type    = "prob")[,2]
  
actual <- as.character(tuds[[target]])
  

# Get unique levels of predicted.

levels_predicted <- unique(predicted)
levels_actual <- unique(actual)
predicted <- as.character(predicted)
predicted_numeric <- ifelse(predicted == levels_predicted[1], 0, 1)
actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(predicted))

# Replace NA or NaN in predicted_numeric.

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# Align vectors (ensure all are of the same length).
# Use the minimum length of the vectors.

min_length <- min(length(predicted_numeric), length(actual_numeric), length(risks))
predicted_numeric <- predicted_numeric[1:min_length]
actual_numeric <- actual_numeric[1:min_length]
risks <- risks[1:min_length]

# Handle missing or invalid values.
# Replace NA or NaN in predicted_numeric with a default value (e.g., 0).

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Replace NA or NaN in actual_numeric with a default value (e.g., 0).

actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Generate risk chart.

svg("TEMPDIR/model_cforest_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks) +
  labs(title       = "Risk Chart - Tuning Dataset") +
  theme(plot.title = element_text(size=14))
dev.off()
