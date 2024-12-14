# Generate error matrix and Hand plot of model ctree.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-11-30 21:41:15 +1100 Graham Williams>
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

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

library(Ckmeans.1d.dp)  # For ggplot.
library(data.table)     # Display data as a nicely formatted table.
library(hmeasure)
library(rattle)         # Provides a convenient wrapper for xgboost.
library(xgboost)        # For XGBoost model.

error_matrix_predic <- predict(model_xgb, newdata = trds, )

target_clean <- trds[[target]][!is.na(error_matrix_predic)]

error_matrix_predic <- error_matrix_predic[!is.na(error_matrix_predic)]


# Get levels from target_clean.

target_levels <- levels(target_clean)

# Convert predicted probabilities into binary class labels based on a threshold.

error_matrix_predic <- ifelse(error_matrix_predic > 0.5, target_levels[2], target_levels[1])

error_matrix_target <- target_clean
