# Generate error matrix and Hand plot of model random forest.
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

library(hmeasure)
library(party)        # Conditional inference trees
library(partykit)     # Enhanced visualization and interpretation

target_ctree_levels <- unique(trds[[target]])
target_ctree_levels <- target_ctree_levels[!is.na(target_ctree_levels)]
  
# Get predicted probabilities for the positive class.

predicted_ctree_probs <- predict(model_ctree, newdata = trds, type = "prob")[,2]

actual_ctree_labels <- ifelse(trds[[target]] == target_ctree_levels[1], 0, 1)

# Evaluate the model using HMeasure.

results <- HMeasure(true.class = actual_ctree_labels, scores = predicted_ctree_probs)
  
svg("TEMPDIR/model_ctree_evaluate_hand.svg")

plotROC(results)

dev.off()

print("Error matrix for the CTREE Decision Tree model (counts)")

error_predic <- predict(model_ctree, newdata = trds, type = "prob")

error_predic <- apply(error_predic, 1, function(x) {
  colnames(error_predic)[which.max(x)]
})

ctree_cem <- rattle::errorMatrix(trds[[target]], error_predic, count = TRUE)

print(ctree_cem)

print('Error matrix for the CTREE Decision Tree model (proportions)')

ctree_per <- rattle::errorMatrix(trds[[target]], error_predic)

print(ctree_per)
