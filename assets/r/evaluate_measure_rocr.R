# Use `actual_va` and `prediction` to generate ROCR plots.
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

complete_cases <- complete.cases(probability, actual_va)
probability_complete <- probability[complete_cases]
actual_complete <- actual_va[complete_cases]
attributes(actual_complete) <- NULL

# Create ROCR prediction object.

pred <- ROCR::prediction(probability_complete, actual_complete)

# Compute AUC for evaluation.

auc <- ROCR::performance(pred, "auc")@y.values[[1]]

# Plot function helper.

generate_plot <- function(pred, measure, y_label, title_label) {
  perf <- ROCR::performance(pred, measure)
  tdf <- data.frame(
    threshold = unlist(perf@x.values),
    value     = unlist(perf@y.values)
  )
  ggplot(tdf, aes(x = threshold, y = value)) +
    geom_line(color = "red") +
    labs(x = "Threshold", y = y_label, title = title_label) +
    annotate("text",
             x     = 0.50,
             y     = 0.00,
             hjust = 0,
             vjust = 0,
             size  = 5,
             label = sprintf('AUC = %.2f', auc)) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.title = element_markdown())
}

svg(glue("<TEMPDIR>/evaluate_{mtype}_rocr_{dtype}.svg"), width=11)

# Generate plots individually.

plot_cost <- generate_plot(pred, "ecost", "Expected Cost", "Cost Curve")
plot_lift <- generate_plot(pred, "lift", "Lift", "Lift Curve")
plot_sens <- generate_plot(pred, "sens", "Sensitivity", "Sensitivity Curve")
plot_prec <- generate_plot(pred, "prec", "Precision", "Precision Curve")

combined_plot <- gridExtra::grid.arrange(
  plot_cost, plot_lift,
  plot_sens, plot_prec,
  ncol = 2,
  top  = "Model Performance Metrics"
)

# Save the combined plot to SVG image.

print(combined_plot)
dev.off()
