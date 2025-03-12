# Use `actual_va` and `prediction` to generate cost curve plots.
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

# 20250309 gjw The ROCR package that we use here does not handle
# missing predictions (NAs) itself so we need to identify and remove
# them.  Notice that we also remove the unnecessary attributes from
# the actual values with the missing excluded.

actual_complete <- na.omit(actual_va)

actual_missing <- attr(actual_complete, "na.action")

attributes(actual_complete) <- NULL

probability_clean <- if (length(actual_missing)) probability[-actual_missing] else probability

# Now remove remaining NAs from probability_clean (minimal-change).

na_in_pred <- is.na(probability_clean)

if (any(na_in_pred)) {
  probability_complete <- probability_clean[!na_in_pred]
  actual_complete <- actual_complete[!na_in_pred]
} else {
  probability_complete <- probability_clean
}

pred <- ROCR::prediction(probability_complete, actual_complete)

# Compute expected cost performance.

perf_ecost <- ROCR::performance(pred, "ecost")
tdf <- data.frame(
  threshold = unlist(perf_ecost@x.values),
  cost      = unlist(perf_ecost@y.values)
)

# Compute AUC.

auc <- ROCR::performance(pred, "auc")@y.values[[1]]

# Informative plot title (Replace placeholders accordingly).

title <- glue(
  "Cost Curve — {mdesc} — {mtype} ",
  "{basename('<FILENAME>')} *{dtype}* ",
  <TARGET_VAR>
)

# Plot to SVG.

svg(glue("<TEMPDIR>/evaluate_{mtype}_cost_curve_{dtype}.svg"), width=11)

tdf %>%
  ggplot(aes(x=threshold, y=cost)) +
  geom_line(color="black") +
  labs(
    title   = title,
    x       = "Threshold",
    y       = "Expected Cost",
    caption = "Lower cost values indicate better model performance"
  ) +
  annotate("text",
           x     = 0.50,
           y     = 0.00,
           hjust = 0,
           vjust = 0,
           size  = 5,
           label = sprintf('AUC = %.2f', auc)) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.title=element_markdown())
dev.off()
