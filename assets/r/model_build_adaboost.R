# Build an AdaBoost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-11-27 11:39:42 +1100 Graham Williams>
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

# Save the model to the TEMPLATE variable `model` and the predicted
# values appropriately.

model <- model_ada

predicted_tr <- predict(model, newdata = trds, type = "prob")[,2]
predicted_tu <- predict(model, newdata = tuds, type = "prob")[,2]
predicted_te <- predict(model, newdata = teds, type = "prob")[,2]


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
  Feature    = names(importance),
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
            size  = 3,
            color = "darkblue")

# Increase plot limits to make space for the labels.

ada_plot <- ada_plot + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  expand_limits(y = max(importance_df$Importance) * 1.2)

# Save the plot to an SVG file.

svg("TEMPDIR/model_ada_boost.svg")
print(ada_plot)
dev.off()

print('Error matrix for the ADABOOST model (counts)')

error_predic <- predict(model_ada, newdata = trds,)

error_predic <- apply(error_predic, 1, function(x) {
  colnames(error_predic)[which.max(x)]
})

adaboost_cem <- rattle::errorMatrix(trds[[target]], error_predic, count = TRUE)

print(adaboost_cem)

print('Error matrix for the ADABOOST model (proportions)')

adaboost_per <- rattle::errorMatrix(trds[[target]], error_predic)

print(adaboost_per)
