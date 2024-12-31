# Generate template variables for evaluating an rpart model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-12-25 17:17:19 +1100 Graham Williams>
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

## #########################################################################
## #########################################################################
## #########################################################################
## 20241220 gjw DO NOT MODIFY THIS FILE WITHOUT DISCUSSION
## #########################################################################
## #########################################################################
## #########################################################################

library(ggtext)       # Support markdown in ggplot titles.
library(glue)         # Format strings: glue().
library(hmeasure)
library(rattle)       # Support: asRules(), fancyRpartPlot().

# 20241220 gjw Save the model to the TEMPLATE variable `model`. This
# will be used below and in the following evaluations if required.
## 20241220 gjw It will also be used in the dart code to identify a
## section of code related to the evaluaation of the rpart model.

model <- model_rpart

# 20241220 gjw Save the predicted values for the three different
# datasets. We should only do this if the dataset is partitioned. That
# has to be fixed.  20241224 zy Save the predicted values based on
# full dataset.

pred_tr <- predict(model, newdata=trds, type="class")
pred_tu <- predict(model, newdata=tuds, type="class")
pred_te <- predict(model, newdata=teds, type="class")
pred_tc <- predict(model, newdata=tcds, type="class")

prob_tr <- predict(model, newdata=trds, type="prob")[,2]
prob_tu <- predict(model, newdata=tuds, type="prob")[,2]
prob_te <- predict(model, newdata=teds, type="prob")[,2]
prob_tc <- predict(model, newdata=tcds, type="prob")[,2]


#target_rpart_levels <- unique(trds[[target]])
#target_rpart_levels <- target_rpart_levels[!is.na(target_rpart_levels)]  # Remove NA if present

# Get predicted probabilities for the positive class.

#predicted_rpart_probs <- predict(model_rpart, newdata = trds, type = "prob")[,2]

#actual_rpart_labels <- ifelse(trds[[target]] == target_rpart_levels[1], 0, 1)

#error_matrix_predic <- predict(model_rpart, newdata = trds, type = "class")

#error_matrix_target <- trds[[target]]

# A variable containing the predictions.

#roc_predicted_probs <- predicted_rpart_probs
