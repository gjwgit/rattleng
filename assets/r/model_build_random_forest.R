# Rattle Scripts: From dataset ds build a random forest model.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2023-09-20 05:07:11 +1000 Graham Williams>
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
# Author: Graham Williams

# Random Forest using randomForest
#
# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(randomForest) # ML: randomForest() na.roughfix() for missing data.

mtype <- "randomForest"
mdesc <- "Forest"

model_randomForest <- randomForest(
  form,
  data=ds[tr, vars], 
  ntree=RF_NUM_TREES,
  mtry=RF_MTRY,
  importance=TRUE,
  na.action=RF_NA_ACTION,
  replace=FALSE)

# Generate textual output of the 'Random Forest' model.

print(model_randomForest)

# The `pROC' package implements various AUC functions.

# Calculate the Area Under the Curve (AUC).

print(pROC::roc(model_randomForest$y,
                as.numeric(model_randomForest$predicted)))

# Calculate the AUC Confidence Interval.

##### print(pROC::ci.auc(crs$rf$y, as.numeric(crs$rf$predicted)))

# List the importance of the variables.

##### rn <- round(randomForest::importance(crs$rf), 2)
##### print(rn[order(rn[,3], decreasing=TRUE),])

