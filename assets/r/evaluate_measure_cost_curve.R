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

# 20250309 gjw Create a ROCR prediction object from the probabilities
# and the corresponding outcome labels. We handle missing predictions
# specially since ROCR is not handling them.

pred <- ROCR::prediction(probability_complete, actual_complete)

# 20250309 gjw ROCR's `performance()` can compute many kinds of
# performance measures. Here we compute the expected cost which is the
# basis of our cost curve.  We extract the x and y values from the
# expeced cost into a temporary data frame for plotting

perf_ecost <- ROCR::performance(pred, "ecost")
tdf <- data.frame(
  threshold = unlist(perf_ecost@x.values),
  cost      = unlist(perf_ecost@y.values)
)

# 20250309 gjw ROCR can also calculate the area under the curve based
# on the ROC curve for added information displayed on the cost curve
# plot.

auc <- ROCR::performance(pred, "auc")@y.values[[1]]

# 20250309 gjw An informative title will present the plot type, the
# model description and specific model type, the data set on which the
# model was built, the dataset used to evaluate the model, and the
# target variable of the model.

title <- glue(
  "Cost Curve — {mdesc} — {mtype} ",
  "{basename('<FILENAME>')} *{dtype}* ",
  <TARGET_VAR>
)

## 20250309 gjw The plot is saved into a specific file named so that
## we can access it from the Rattle app.

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
