# Using the dataset ds build an rpart decision tree.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-11-27 22:21:00 +1100 Graham Williams>
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

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(rattle)
library(rpart)        # ML: decision tree rpart().

mtype <- "rpart"
mdesc <- "Traditional Decision Tree through Recursive Partitioning"

# Determine what type of model to build, based on the number of values
# of the target variable.

method <- ifelse(ds[[target]] %>% unique() %>% length() > 10,
                 "anova",
                 "class")

# Train a decision tree model.

model_rpart <- rpart(
  form,
  data    = trds,
  method  = method,
  parms   = list(split="information" PRIORS LOSS),
  control = rpart.control(usesurrogate = 0,
                          maxsurrogate = 0, 
                          MINSPLIT, MINBUCKET, MAXDEPTH, CP),
  model   = TRUE)

# Output a textual view of the Decision Tree model.

print(model_rpart)
printcp(model_rpart)
cat("\n")

# Plot the resulting Decision Tree using the rpart.plot package via
# Rattle's fancyRpartPlot().

svg("TEMPDIR/model_tree_rpart.svg")
rattle::fancyRpartPlot(model_rpart,
                       main = "Decision Tree weather.csv $ TARGET_VAR",
                       sub  = paste("TIMESTAMP", username))
dev.off()

# Output the rules from the tree.

rattle::asRules(model_rpart)

# Extract and print rules.

rules <- rattle::asRules(model_rpart)
  
# Prepare probabilities for predictions as the number of columns as
# there are target values.

pr_tu <- predict(model_rpart, newdata = tuds)[,2]

# Use rattle's evaluateRisk.

eval <- rattle::evaluateRisk(pr_tu, actual_tu, risk_tu)

# Generate the risk chart.

svg("TEMPDIR/model_rpart_risk.svg")
rattle::riskchart(pr_tu, actual_tu, risk_tu,
                  title          = "Risk Chart Decision Tree weather.csv [tuning] TARGET_VAR ", 
                  risk.name      = "RISK_MM",
                  recall.name    = "TARGET_VAR",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE) +
    SETTINGS_GRAPHIC_THEME()
dev.off()
