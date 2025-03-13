# Use `actual_va` and `prediction` to generate sensitivity plots.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2025-03-09 08:41:23 +1100 Graham Williams>
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

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# Remove observations with missing target values.

actual_complete <- na.omit(actual_va)

actual_missing <- attr(actual_complete, "na.action")

attributes(actual_complete) <- NULL  # Remove unnecessary attributes

# Align predictions with non-missing target values.

probability_clean <- if (length(actual_missing)) probability[-actual_missing] else probability

# Remove remaining NAs from probability_clean.

na_in_pred <- is.na(probability_clean)

if (any(na_in_pred)) {
  probability_complete <- probability_clean[!na_in_pred]
  actual_complete <- actual_complete[!na_in_pred]
} else {
  probability_complete <- probability_clean
}

# Create a ROCR prediction object from probabilities and actual labels.

pred <- ROCR::prediction(probability_complete, actual_complete)

# Compute sensitivity and specificity performance.

perf_sens_spec <- ROCR::performance(pred, "sens", "spec")

# Convert to a tidy dataframe for plotting.

sensitivity_df <- data.frame(
  specificity = unlist(perf_sens_spec@x.values),
  sensitivity = unlist(perf_sens_spec@y.values)
)

# Compute AUC for evaluation.

auc <- ROCR::performance(pred, "auc")@y.values[[1]]

# Generate an informative title.

title <- glue(
  "Sensitivity/Specificity — {mdesc} — {mtype} ",
  "{basename('<FILENAME>')} *{dtype}* ",
  <TARGET_VAR>
)

# Save the sensitivity/specificity chart as an SVG file.

svg(glue("<TEMPDIR>/evaluate_{mtype}_sensitivity_{dtype}.svg"), width = 11)

# Generate the Sensitivity/Specificity plot.

sensitivity_df %>%
  ggplot(aes(x = specificity, y = sensitivity)) +
  geom_line(color = "black") +
  labs(
    title   = title,
    x       = "Specificity (True Negative Rate)",
    y       = "Sensitivity (True Positive Rate)",
    caption = "Higher sensitivity and specificity indicate better model performance"
  ) +
  annotate("text",
           x     = 0.50,
           y     = 0.00,
           hjust = 0,
           vjust = 0,
           size  = 5,
           label = sprintf('AUC = %.2f', auc)) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.title = element_markdown())

dev.off()