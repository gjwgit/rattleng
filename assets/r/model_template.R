# Rattle Scripts: Setup the model template variables.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-11-27 11:20:33 +1100 Graham Williams>
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
# Run this script after the variable `ds` (dataset) and other data
# template variables have been defined as in `data_template.R`. this
# script will initialise the model template variables.
#
# References:
#
# @williams:2017:essentials Chapter 7.
#
# https://survivor.togaware.com/datascience/model-template.html

library(stringi)      # The string concat operator %s+%.

ignore <- c(risk, id, IGNORE_VARS)
vars   <- setdiff(vars, ignore)
inputs <- setdiff(vars, target)

# Generate the formula to be used for predictive modelling.

form   <- formula(target %s+% " ~ .")

print(form)

# Identify a subset of the full dataset that has values for the
# target variable, rmoving those rows that do not have a target. We
# will only use such data, the target complete dataset (tcds), for the
# predictive modelling.

tcds <- ds[!is.na(ds[[target]]),]

# Update the number of `obs` appropriately

tcnobs <- nrow(tcds)

if (SPLIT_DATASET) {

  # Split the dataset into train, tune, and test, recording the indicies
  # of the observations to be associated with each dataset. If the
  # dataset is not to be partitioned, simply have the train, tune and
  # test datasets as the whole dataset.

  # Specify the three way split for the dataset: training (tr) and
  # tuning (tu) and testing (te).
  
  split <- c(DATA_SPLIT_TR_TU_TE)

  
  tr <- tcnobs %>% sample(split[1]*tcnobs)
  tu <- tcnobs %>% seq_len() %>% setdiff(tr) %>% sample(split[2]*tcnobs)
  te <- tcnobs %>% seq_len() %>% setdiff(tr) %>% setdiff(tu)

} else {

  # If the user has decided not to partition the data we will build
  # the model and tune/test the model on the same dataset.
  
  tr <- tu <- te <- seq_len(tcnobs)
}

# Note the actual target values and the risk values.

actual_tr <- tcds %>% slice(tr) %>% pull(target)
actual_tu <- tcds %>% slice(tu) %>% pull(target)
actual_te <- tcds %>% slice(te) %>% pull(target)
  
if (!is.null(risk))
{
  risk_tr <- tcds %>% slice(tr) %>% pull(risk)
  risk_tu <- tcds %>% slice(tu) %>% pull(risk)
  risk_te <- tcds %>% slice(te) %>% pull(risk)
}

# Subset the training, tuning, and testing datasets.

trds <- tcds[tr, setdiff(vars, ignore)]
tuds <- tcds[tu, setdiff(vars, ignore)]
teds <- tcds[te, setdiff(vars, ignore)]

# Identify predictor variables (excluding the target variable).

# WHY IS THIS NEEDED - USE INPUTS predictor_vars <- setdiff(vars, target)

# Identify categoric and numeric input variables.

cat_vars <- names(Filter(function(col) is.factor(col) || is.character(col), ds[inputs]))
num_vars <- setdiff(inputs, cat_vars)

# TODO 20241112 gjw FIX THIS CLUMSY NAME

ignore_categoric_vars <- c(num_vars, target)

# 

neural_ignore_categoric <- NEURAL_IGNORE_CATEGORIC

