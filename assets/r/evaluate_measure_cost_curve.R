# Use `actual` and `prediction` to generate cost curve plots.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2025-02-02 14:48:05 +1100 Graham Williams>
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
# Author: Zheyuan Xu

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# Remove observations with missing target values.

no.miss <- na.omit(actual_va)
miss.list <- attr(no.miss, "na.action")
attributes(no.miss) <- NULL  # Remove unnecessary attributes

# Align predictions with non-missing target values.

pred <- if (length(miss.list)) {
  ROCR::prediction(probability[-miss.list], no.miss)
} else {
  ROCR::prediction(probability, no.miss)
}

# Compute expected cost performance.

perf_ecost <- ROCR::performance(pred, "ecost")

# Extract the Area Under the Curve (AUC) value for the ROC curve.

au <- ROCR::performance(pred, "auc")@y.values[[1]]

# Convert performance object to a tidy dataframe.

cost_df <- data.frame(
  threshold = unlist(perf_ecost@x.values),
  cost = unlist(perf_ecost@y.values)
)

# Generate dynamic plot title using glue.

title_text <- glue(
  "Cost Curve — {mdesc} — {mtype} {basename('<FILENAME>')} *{dtype}* ", <TARGET_VAR>
)

svg(glue("<TEMPDIR>/model_evaluate_cost_curve_{mtype}_{dtype}.svg"), width = 11)

# Create the cost curve plot.

cost_df %>%
  ggplot(aes(x = threshold, y = cost)) +
  geom_line(color = "black") +
  labs(
    title = title_text,
    x = "Threshold",
    y = "Expected Cost",
    caption = "Lower cost values indicate better model performance"
  ) +
  annotate("text",
           x     = 0.50,
           y     = 0.00,
           hjust = 0,
           vjust = 0,
           size  = 5,
           label = sprintf('AUC = %.2f', au)) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.title = element_markdown())
dev.off()
