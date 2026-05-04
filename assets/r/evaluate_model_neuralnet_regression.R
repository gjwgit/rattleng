# Define `pred_ra` and `prob_ra` for a neuralnet regression model.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <2025 Graham Williams>
#
# Author: Graham Williams

# Rattle timestamp: <TIMESTAMP>

model <- model_neuralnet

mtype <- "neuralnet"
mdesc <- "Neural Network (Regression)"

# neuralnet::compute() returns a list; extract the net.result column.

pred_ra <- function(model, data) {
  # Select only the input columns used during training.
  input_cols <- intersect(colnames(data), model$model.list$variables)
  preds <- neuralnet::compute(model, data[, input_cols, drop = FALSE])
  as.numeric(preds$net.result)
}

prob_ra <- function(model, data) {
  input_cols <- intersect(colnames(data), model$model.list$variables)
  preds <- neuralnet::compute(model, data[, input_cols, drop = FALSE])
  as.numeric(preds$net.result)
}
