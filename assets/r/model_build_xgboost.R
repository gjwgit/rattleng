# Build an XGBoost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 16:02:03 +1100 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but <WITHOUT>
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR MORE <DETAILS>.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Zheyuan Xu

# Load required libraries.

library(Ckmeans.1d.dp)  # For ggplot.
library(data.table)     # Display data as a nicely formatted table.
library(rattle)         # Provides a convenient wrapper for xgboost.
library(xgboost)        # For XGBoost model.

# Define model type and description.

mtype <- "xgboost"
mdesc <- "XGBoost"

model_xgb <- rattle::xgboost(form,
                     data              = trds,
                     max_depth         = <BOOST_MAX_DEPTH>,     # Maximum depth of a tree
                     eta               = <BOOST_LEARNING_RATE>, # Learning rate
                     nthread           = <BOOST_THREADS>,       # Set the number of threads
                     num_parallel_tree = 1,
                     nrounds           = <BOOST_ITERATIONS>,
                     metrics           = 'error',
                     objective         = <BOOST_OBJECTIVE>, )

# Save the model to the <TEMPLATE> variable `model` and the predicted
# values appropriately.

model <- model_xgb

predicted_tr <- predict(model, newdata = trds)
predicted_tu <- predict(model, newdata = tuds)
predicted_te <- predict(model, newdata = teds)

# Print the summary of the trained model.

print(model_xgb)
summary(model_xgb)

# Feature Importance Plot.

svg("<TEMPDIR>/model_xgb_importance.svg")
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
