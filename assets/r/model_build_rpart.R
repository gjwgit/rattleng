# From dataset `ds` build an `rpart()` decision tree.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-12-12 17:19:07 +1100 Graham Williams>
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

# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(ggtext)       # Support markdown in ggplot titles.
library(glue)         # Format strings: glue().
library(hmeasure)
library(rattle)       # Support: asRules(), fancyRpartPlot().
library(rpart)        # ML: decision tree rpart().

# Define the model type and description for file paths and titles.

mtype <- "rpart"
mdesc <- "Decision Tree"

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

# Save the model to the TEMPLATE variable `model` and the predicted
# values appropriately.

model <- model_rpart

predicted_tr <- predict(model, newdata = trds)[,2]
predicted_tu <- predict(model, newdata = tuds)[,2]
predicted_te <- predict(model, newdata = teds)[,2]

# Output a textual view of the Decision Tree model.

print(model_rpart)
printcp(model_rpart)
cat("\n")

# Output the rules from the tree.

rattle::asRules(model_rpart)

# Plot the resulting Decision Tree using the rpart.plot package via
# Rattle's fancyRpartPlot().

svg(glue("TEMPDIR/model_tree_{mtype}.svg"))
rattle::fancyRpartPlot(model_rpart,
                       main = "Decision Tree FILENAME $ TARGET_VAR",
                       sub  = paste("TIMESTAMP", username))
dev.off()
