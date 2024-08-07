# Rattle Scripts: From dataset ds build a random forest model.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-14 20:46:11 +1000 Graham Williams>
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

# Random Forest using randomForest()
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(randomForest) # ML: randomForest() na.roughfix() for missing data.

mtype <- "randomForest"
mdesc <- "Forest"

# Typically we use na.roughfix() for na.action.

tds <- ds[tr, vars]

model_randomForest <- randomForest(
  form,
  data=tds, 
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

print(pROC::ci.auc(model_randomForest$y, as.numeric(model_randomForest$predicted)))

# List the importance of the variables.

rn <- round(randomForest::importance(model_randomForest), 2)
rn[order(rn[,3], decreasing=TRUE),]

# Plot the relative importance of the variables.

svg("TEMPDIR/model_random_forest_varimp.svg")
ggVarImp(model_randomForest,
         title="Variable Importance Random Forest weather.csv")
dev.off()

# p <- ggVarImp(crs$rf,
#              title="Variable Importance Random Forest weather.csv")
# p

# Plot the error rate against the number of trees.

## plot(crs$rf, main="")
## legend("topright", c("OOB", "No", "Yes"), text.col=1:6, lty=1:3, col=1:3)
## title(main="Error Rates Random Forest weather.csv",
##     sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

# Display tree number 1.

printRandomForests(model_randomForest, 1)

# Plot the OOB ROC curve.

## library(verification)
## aucc <- verification::roc.area(as.integer(as.factor(crs$dataset[crs$train, crs$target]))-1,
##                  crs$rf$votes[,2])$A
## verification::roc.plot(as.integer(as.factor(crs$dataset[crs$train, crs$target]))-1,
##          crs$rf$votes[,2], main="")
## legend("bottomright", bty="n",
##        sprintf("Area Under the Curve (AUC) = %1.3f", aucc))
## title(main="OOB ROC Curve Random Forest weather.csv",
##     sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))
