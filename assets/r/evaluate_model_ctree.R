# Generate template variables for evaluating a ctree model.
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
## section of code related to the evaluation of the ctree model.

model <- model_ctree

# 20241220 gjw Save the predicted values for the three different
# datasets. We should only do this if the dataset is partitioned. That
# has to be fixed.  20241224 zy Save the predicted values based on
# full dataset.

pred_tr <- predict(model, newdata = trds, type = "prob")
pred_tu <- predict(model, newdata = tuds, type = "prob")
pred_te <- predict(model, newdata = teds, type = "prob")
pred_tc <- predict(model, newdata = tcds, type = "prob")

# Finds the index of the column with the highest value in each row of 'pred_tr'.

pred_tr <- colnames(pred_tr)[max.col(pred_tr, ties.method = "first")]
pred_tu <- colnames(pred_tu)[max.col(pred_tu, ties.method = "first")]
pred_te <- colnames(pred_te)[max.col(pred_te, ties.method = "first")]
pred_tc <- colnames(pred_tc)[max.col(pred_tc, ties.method = "first")]

prob_tr <- predict(model, newdata=trds, type="prob")[,2]
prob_tu <- predict(model, newdata=tuds, type="prob")[,2]
prob_te <- predict(model, newdata=teds, type="prob")[,2]
prob_tc <- predict(model, newdata=tcds, type="prob")[,2]
