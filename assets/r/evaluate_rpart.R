# Generate error matrix and Hand plot of model rpart.
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

library(ggtext)       # Support markdown in ggplot titles.
library(glue)         # Format strings: glue().
library(hmeasure)
library(rattle)       # Support: asRules(), fancyRpartPlot().
library(rpart)        # ML: decision tree rpart().

target_rpart_levels <- unique(trds[[target]])
target_rpart_levels <- target_rpart_levels[!is.na(target_rpart_levels)]  # Remove NA if present
  
# Get predicted probabilities for the positive class.

predicted_rpart_probs <- predict(model_rpart, newdata = trds, type = "prob")[,2]

actual_rpart_labels <- ifelse(trds[[target]] == target_rpart_levels[1], 0, 1)

# Evaluate the model using HMeasure.

results <- HMeasure(true.class = actual_rpart_labels, scores = predicted_rpart_probs)
  
svg("TEMPDIR/model_rpart_evaluate_hand.svg")

plotROC(results)

dev.off()

print("Error matrix for the RPART Decision Tree model (counts)")

error_predic <- predict(model_rpart, newdata = trds, type = "class")

rpart_cem <- rattle::errorMatrix(trds[[target]], error_predic, count = TRUE)

print(rpart_cem)

print('Error matrix for the RPART Decision Tree model (proportions)')

rpart_per <- rattle::errorMatrix(trds[[target]],error_predic)

print(rpart_per)
