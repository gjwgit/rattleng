# Rattle Scripts: From dataset ds build an rpart decision tree.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2023-11-06 15:53:21 +1100 Graham Williams>
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

# Decision Tree using RPART
#
# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# The 'rpart' package provides the 'rpart' function.

library(rpart)        # ML: decision tree rpart().

mtype <- "rpart"
mdesc <- "Tree"

# Determine what type of model to build, based on the number of values
# of the target variable.

method <- ifelse(ds[[target]] %>% unique() %>% length() > 10,
                 "anova", "class")
method

# Train a decision tree model.

model_rpart <- rpart(
  form,
  data=ds[tr, vars],
  method=method,
  parms=list(split="information" PRIORS LOSS),
  control=rpart.control(usesurrogate=0,
                        maxsurrogate=0 MINSPLIT MINBUCKET CP),
  model=TRUE)

# Generate a textual view of the Decision Tree model.

print(model_rpart)
printcp(model_rpart)
cat("\n")
