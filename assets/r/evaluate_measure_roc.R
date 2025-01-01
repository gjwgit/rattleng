# Using `actual` and `prediction` to generate ROC/AUC plots.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-01-01 21:02:26 +1100 Graham Williams>
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

## #########################################################################
## #########################################################################
## #########################################################################
## 20241220 gjw DO NOT MODIFY THIS FILE WITHOUT DISCUSSION
## #########################################################################
## #########################################################################
## #########################################################################

# Load required packages from the local library into the R session.

library(ggplot2, quietly = TRUE)
library(glue)
library(ROCR)

################################

title <- glue(
    "ROC Curve &#8212; {mdesc} &#8212; ",
    "{mtype} {basename('FILENAME')} ",
    "*{dtype}* TARGET_VAR"
)

# Remove observations with missing target values.

no.miss <- na.omit(actual)

# Retrieve the indices of missing values.

miss.list <- attr(no.miss, "na.action")

# Remove unnecessary attributes to keep the actual target labels clean.

attributes(no.miss) <- NULL

# Handle predictions to align with non-missing values.

target_levels <- levels(as.factor(actual))  # Retrieve unique levels
actual_model_labels <- ifelse(actual == target_levels[1], 0, 1)

# Create prediction object using probability and binary labels.
# Identify positions where either vector has NA.

na_positions <- is.na(probability) | is.na(actual_model_labels)

# Remove NA positions from both vectors.

roc_predicted_probs <- probability[!na_positions]
actual_model_labels <- actual_model_labels[!na_positions]

# Convert roc_predicted_probs to numeric.

roc_predicted_probs <- as.numeric(factor(probability)) - 1

# Find the lengths of the two objects.

len_actual_target <- length(actual_model_labels)
len_roc_predicted_predic <- length(probability)

# Determine the minimum length.

roc_min_length <- min(len_actual_target, len_roc_predicted_predic)

# Match the minimum length.

roc_predicted_probs <- probability[seq_len(roc_min_length)]
actual_model_labels <- actual_model_labels[seq_len(roc_min_length)]

# Generate a prediction object that combines the predicted probability and actual labels.

prediction_prob_values <- prediction(roc_predicted_probs, actual_model_labels)

# Compute performance metrics: True Positive Rate (TPR) and False Positive Rate (FPR).

pe <- performance(prediction_prob_values, "tpr", "fpr")

# Extract the Area Under the Curve (AUC) value for the ROC curve.

au <- performance(prediction_prob_values, "auc")@y.values[[1]]

# Create a data frame containing the FPR and TPR values for plotting the ROC curve.

pd <- data.frame(fpr = unlist(pe@x.values), tpr = unlist(pe@y.values))

fname <- glue("TEMPDIR/model_evaluate_roc_{mtype}_{dtype}.svg")
svg(fname, width = 11)

# 20241220 gjw Now render the ROC curve with the FPR and TPR data.
# The red line represent the ROC curve while the diagonal grey
# reference line indicates a random classifier (baseline).

pd %>%
  ggplot(aes(x=fpr, y=tpr)) +
  geom_line(colour = "red") +
  xlab("False Positive Rate") +
  ylab("True Positive Rate") +
  ggtitle(title) +
  theme(plot.title=element_text(size=12, face="bold", hjust=0.5, colour="darkblue")) +
  geom_line(data=data.frame(), aes(x=c(0, 1), y=c(0, 1)), colour="grey") +
  annotate("text",
           x     = 0.50,
           y     = 0.00,
           hjust = 0,
           vjust = 0,
           size  = 5,
           label = paste("AUC =", round(au, 2))) +
  SETTINGS_GRAPHIC_THEME() +
  theme(plot.title = element_markdown())
dev.off()
