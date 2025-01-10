# Rattle Scripts: From dataset ds build a random forest model.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-12-03 12:41:27 +1100 Graham Williams>
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

library(rattle)
library(randomForest) # ML: randomForest() na.roughfix() for missing data.
library(ggplot2)
library(glue)         # Format strings: glue().
library(kernlab)
library(rattle)
library(reshape2)
library(verification)

mtype <- "randomForest"
mdesc <- "Random Forest"

model_randomForest <- randomForest(
  form,
  data       = trds, 
  ntree      = RF_NUM_TREES,
  mtry       = RF_MTRY,
  importance = TRUE,
  na.action  = RF_NA_ACTION,
  replace    = FALSE)

########################################################################

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

# Display tree number 1.

printRandomForests(model_randomForest, RF_NO_TREE)

# Plot the relative importance of the variables.

svg("TEMPDIR/model_random_forest_varimp.svg")

# Assuming `model_randomForest` is already trained.
# Extract variable importance for each class.

importance_matrix <- importance(model_randomForest)

# Convert to a data frame for easy plotting.

importance_df <- as.data.frame(importance_matrix)
importance_df$Variable <- rownames(importance_df)

# Melt the data frame to long format for ggplot.

importance_long <- melt(importance_df, 
                        id.vars       = "Variable", 
                        variable.name = "Class", 
                        value.name    = "Importance")

ggplot(importance_long, aes(x    = reorder(Variable, Importance), 
                            y    = Importance, 
                            fill = Class)) +
  geom_bar(stat     = "identity", 
           position = "dodge") +
  coord_flip() +
  labs(
    title = "Variable Importance for Different Target Classes",
    x     = "Variable",
    y     = "Importance"
  ) +
  theme_minimal()

dev.off()


# Plot the error rate against the number of trees.

svg("TEMPDIR/model_random_forest_error_rate.svg")

plot(model_randomForest, main="")
legend("topright", c("OOB", "No", "Yes"), 
       text.col = 1:6, 
       lty      = 1:3, 
       col      = 1:3)
title(main="Error Rates Random",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

dev.off()
