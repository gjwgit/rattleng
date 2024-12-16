# Generate error matrix and Hand plot of model adaboost.
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

library(ada)
library(caret)
library(ggplot2)
library(hmeasure)
library(rattle)
library(rpart)


target_ada_levels <- unique(trds[[target]])
target_ada_levels <- target_ada_levels[!is.na(target_ada_levels)]
  
# Get predicted probabilities for the positive class.

predicted_ada_probs <- predict(model_ada, newdata = trds, type = "prob")[,2]

actual_ada_labels <- ifelse(trds[[target]] == target_ada_levels[1], 0, 1)

# Evaluate the model using HMeasure.

results <- HMeasure(true.class = actual_ada_labels, scores = predicted_ada_probs)
  
svg("TEMPDIR/model_ada_evaluate_hand.svg")

plotROC(results)

dev.off()

error_matrix_predic <- predict(model_ada, newdata = trds,)

# Set the predict value as the level of max value in the row.

error_matrix_predic <- apply(error_matrix_predic, 1, function(x) {
  colnames(error_matrix_predic)[which.max(x)]
})

error_matrix_target <- trds[[target]]
