# Define `pred_ra` and `prob_ra` for a nnet regression model.
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

model <- model_nn

mtype <- "nnet"
mdesc <- "Neural NNET (Regression)"

# For regression nnet (linear output), predict() returns a numeric matrix;
# drop to a plain numeric vector.

pred_ra <- function(model, data) as.numeric(predict(model, newdata = data))

prob_ra <- function(model, data) as.numeric(predict(model, newdata = data))
