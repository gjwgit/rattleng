# Define `pred_ra` and `prob_ra` for an SVM regression model.
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

model <- model_svm

mtype <- "svm"
mdesc <- "Support Vector Machine (Regression)"

# For regression SVM (type="eps-regression"), predict() returns a numeric vector.

pred_ra <- function(model, data) as.numeric(predict(model, newdata = data))

prob_ra <- function(model, data) as.numeric(predict(model, newdata = data))
