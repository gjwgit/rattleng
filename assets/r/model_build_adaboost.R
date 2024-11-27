# Build an AdaBoost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-10-08 15:58:47 +1100 Graham Williams>
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

library(ada)
library(rattle) 
library(rpart)
library(caret)
library(ggplot2)

# Define model type and description.

mtype <- "adaboost"
mdesc <- "Adaptive Boosting (AdaBoost)"

# Set parameters for the AdaBoost model.

ada_control <- rpart.control(maxdepth = BOOST_MAX_DEPTH,
                             cp       = BOOST_COMPLEXITY,
                             minsplit = BOOST_MIN_SPLIT,
                             xval     = BOOST_X_VALUE)

# Train the AdaBoost model.

model_ada <- ada(form,
                 data    = trds, 
                 iter    = BOOST_ITERATIONS,
                 type    = "gentle", # Type of boosting.
                 control = ada_control)

# Print the summary of the trained model.

print(model_ada)
summary(model_ada)

####################################
# Create importance plot.
####################################

# Calculate feature importance.

importance <- varplot(model_ada, type = "scores", main = "", plot = FALSE)

# Convert the named vector into a data frame.

importance_df <- data.frame(
  Feature = names(importance),
  Importance = importance
)

# Order the data frame by importance in descending order.

importance_df <- importance_df[order(-importance_df$Importance),]

# Create the ggplot-based importance plot.

ada_plot <- ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(x = "Features", y = "Importance",
       title = "Feature Importance in AdaBoost Model",
       subtitle = paste("Model:", mdesc)) +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8))

# Add value labels to the bars.

ada_plot <- ada_plot +
  geom_text(aes(label = sprintf("%.4f", Importance), y = Importance),
            hjust = -0.1,
            size = 3,
            color = "darkblue")

# Increase plot limits to make space for the labels.

ada_plot <- ada_plot + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  expand_limits(y = max(importance_df$Importance) * 1.2)

# Save the plot to an SVG file.

svg("TEMPDIR/model_ada_boost.svg")
print(ada_plot)
dev.off()

# Prepare probabilities for predictions.

predicted <- predict(model_ada, 
                     newdata = tuds,
                     type    = "prob")[,2]

# Get unique levels of predicted.

levels_predicted <- unique(predicted)
predicted <- as.character(predicted)
predicted_numeric <- ifelse(predicted == levels_predicted[1], 0, 1)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(predicted))

# Replace NA or NaN in predicted_numeric.

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Replace NA or NaN in actual_numeric.

actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Step 1: Ensure predicted_numeric has valid probabilities (0 to 1).

predicted_numeric <- ifelse(predicted_numeric < 0 | is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Step 2: Ensure actual_numeric is binary (0 or 1).

actual_numeric <- ifelse(actual_numeric < 0 | actual_numeric > 1 | is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Step 3: Ensure all vectors have the same length.

min_length <- min(length(predicted_numeric), length(actual_numeric), length(risks))
predicted_numeric <- predicted_numeric[1:min_length]
actual_numeric <- actual_numeric[1:min_length]
risks <- risks[1:min_length]

# Step 4: Ensure predicted_numeric has valid probabilities (0 to 1).

predicted_numeric <- pmin(pmax(predicted_numeric, 0), 1)

# Generate risk chart.

svg("TEMPDIR/model_adaboost_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks) +
  labs(title = "Risk Chart - Tuning Dataset") +
  theme(plot.title = element_text(size=14))
dev.off()
