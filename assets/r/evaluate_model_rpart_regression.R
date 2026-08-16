# Define `pred_ra` and `prob_ra` for an rpart regression model.
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
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html

# Save the model to the <TEMPLATE> variable `model`.

model <- model_rpart

# Specify the model type and description for regression.

mtype <- "rpart"
mdesc <- "Decision Tree (Regression)"

# For regression rpart, predict() returns a numeric vector by default.

pred_ra <- function(model, data) as.numeric(predict(model, newdata = data))

# prob_ra mirrors pred_ra for regression (no class probabilities).

prob_ra <- function(model, data) as.numeric(predict(model, newdata = data))
