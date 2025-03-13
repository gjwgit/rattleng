# Use `actual_va` and `prediction` to generate lift plot.
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

# Remove remaining NAs from probability_clean (minimal change).

na_in_pred <- is.na(probability_clean)

if (any(na_in_pred)) {
  probability_complete <- probability_clean[!na_in_pred]
  actual_complete <- actual_complete[!na_in_pred]
} else {
  probability_complete <- probability_clean
}

# Create a ROCR prediction object from the probabilities
# and the corresponding outcome labels.

pred <- ROCR::prediction(probability_complete, actual_complete)

# Compute lift performance and transform to percentage.

perf_lift <- ROCR::performance(pred, "lift", "rpp")
perf_lift@x.values[[1]] <- perf_lift@x.values[[1]] * 100  # Convert rate of positive predictions to percentage

# Compute AUC for additional model evaluation.

auc <- ROCR::performance(pred, "auc")@y.values[[1]]

# Create an informative title for the plot.

title <- glue(
  "Lift Chart — {mdesc} — {mtype} ",
  "{basename('<FILENAME>')} *{dtype}* ",
  <TARGET_VAR>
)

# Save the lift chart as an SVG file.

svg(glue("<TEMPDIR>/evaluate_{mtype}_lift_{dtype}.svg"), width = 11)

# Generate the lift chart using ggplot2.

lift_df <- data.frame(
  percentage = unlist(perf_lift@x.values),
  lift       = unlist(perf_lift@y.values)
)

lift_df %>%
  ggplot(aes(x = percentage, y = lift)) +
  geom_line(color = "black") +
  labs(
    title   = title,
    x       = "Caseload (%)",
    y       = "Lift",
    caption = "Higher lift values indicate better model performance"
  ) +
  annotate("text",
           x     = 50,
           y     = min(lift_df$lift, na.rm = TRUE) + 0.05,
           hjust = 0,
           vjust = 0,
           size  = 5,
           label = sprintf('AUC = %.2f', auc)) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.title = element_markdown())

dev.off()
