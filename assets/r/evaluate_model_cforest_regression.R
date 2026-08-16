# Define `pred_ra` and `prob_ra` for a conditional forest regression model.
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

model <- model_conditionalForest

mtype <- "cforest"
mdesc <- "Conditional Forest (Regression)"

# For regression cforest, predict() returns a named numeric vector.

pred_ra <- function(model, data) {
  preds <- predict(model, newdata = data)
  as.numeric(unlist(preds))
}

prob_ra <- function(model, data) {
  preds <- predict(model, newdata = data)
  as.numeric(unlist(preds))
}
