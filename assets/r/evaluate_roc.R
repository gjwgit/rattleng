# Use `prediction` to generate ROC/AUC plots.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2024-12-20 12:01:33 +1100 Graham Williams>
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
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(ggplot2, quietly = TRUE)
library(glue)
library(ROCR)

################################

title <- glue("ROC Curve &#8212; {mdesc} &#8212; ",
              "{mtype} {basename('FILENAME')} ",
              "*{dtype}* TARGET_VAR")

# Remove observations with missing target values.

no.miss <- na.omit(trds[[target]])

# Retrieve the indices of missing values.

miss.list <- attr(no.miss, "na.action")

# Remove unnecessary attributes to keep the actual target labels clean.

attributes(no.miss) <- NULL

# Handle predictions to align with non-missing values.

target_levels <- levels(as.factor(trds[[target]]))  # Retrieve unique levels
actual_model_labels <- ifelse(trds[[target]] == target_levels[1], 0, 1)

# Create prediction object using probabilities and binary labels.
# Identify positions where either vector has NA.

na_positions <- is.na(roc_predicted_probs) | is.na(actual_model_labels)

# Remove NA positions from both vectors.

roc_predicted_probs <- roc_predicted_probs[!na_positions]
actual_model_labels <- actual_model_labels[!na_positions]

# Convert roc_predicted_probs to numeric.

roc_predicted_probs <- as.numeric(factor(roc_predicted_probs)) - 1

# Find the lengths of the two objects.

len_actual_target <- length(actual_model_labels)
len_roc_predicted_predic <- length(roc_predicted_probs)

# Determine the minimum length.

roc_min_length <- min(len_actual_target, len_roc_predicted_predic)

# Match the minimum length.

roc_predicted_probs <- roc_predicted_probs[seq_len(roc_min_length)]
actual_model_labels <- actual_model_labels[seq_len(roc_min_length)]

# Generate a prediction object that combines the predicted probabilities and actual labels.

prediction_prob_values <- prediction(roc_predicted_probs, actual_model_labels)

# Compute performance metrics: True Positive Rate (TPR) and False Positive Rate (FPR).

pe <- performance(prediction_prob_values, "tpr", "fpr")

# Extract the Area Under the Curve (AUC) value for the ROC curve.

au <- performance(prediction_prob_values, "auc")@y.values[[1]]

# Create a data frame containing the FPR and TPR values for plotting the ROC curve.

pd <- data.frame(fpr = unlist(pe@x.values), tpr = unlist(pe@y.values))

# Initialize a ggplot object with the FPR and TPR data, setting up axes for the ROC curve.

p <- ggplot(pd, aes(x = fpr, y = tpr))

# Add a red line to represent the ROC curve.

p <- p + geom_line(colour = "red")

# Label the x-axis as "False Positive Rate" and the y-axis as "True Positive Rate".

p <- p + xlab("False Positive Rate") + ylab("True Positive Rate")

# Add a title to the plot and customize its appearance.

p <- p + ggtitle(title)
p <- p + theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5, colour = "darkblue"))

# Add a diagonal grey reference line indicating a random classifier (baseline).

p <- p + geom_line(data = data.frame(), aes(x = c(0, 1), y = c(0, 1)), colour = "grey")

# Annotate the plot with the AUC value at a specific position.

p <- p + annotate("text", x = 0.50, y = 0.00, hjust = 0, vjust = 0, size = 5,
                   label = paste("AUC =", round(au, 2)))

p <- p +
  SETTINGS_GRAPHIC_THEME() +
  theme(plot.title = element_markdown())

image_title <- glue("TEMPDIR/model_{mtype}_evaluate_roc.svg")

svg(image_title, width = 11)

print(p)

dev.off()
