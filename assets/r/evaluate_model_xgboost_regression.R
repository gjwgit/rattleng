# Define `pred_ra` and `prob_ra` for an xgboost regression model.
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

model <- model_xgb

mtype <- "xgboost"
mdesc <- "Extreme Boost (Regression)"

# For regression XGBoost (objective="reg:squarederror"), predict() returns
# a plain numeric vector.

pred_ra <- function(model, data) as.numeric(xgb_predict(model, data))

prob_ra <- function(model, data) as.numeric(xgb_predict(model, data))
