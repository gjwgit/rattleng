# Rattle Scripts: Setup the model template variables.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-14 20:30:22 +1000 Graham Williams>
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

ignore <- c(risk, id)
vars   <- setdiff(vars, ignore)
inputs <- setdiff(vars, target)

# Generate the formula to be used for predictive modelling.

form   <- formula(target %s+% " ~ .")

print(form)

# Split the dataset into train, tune, and test, recording the indicies
# of the observations to be associated with each dataset. If the
# dataset is not to be partitioned, simply have the train, tune and
# test datasets as the whole dataset.

if (SPLIT_DATASET) {

  split <- c(DATA_SPLIT_TR_TU_TE)

  nobs %>% sample(split[1]*nobs)                               -> tr
  nobs %>% seq_len() %>% setdiff(tr) %>% sample(split[2]*nobs) -> tu
  nobs %>% seq_len() %>% setdiff(tr) %>% setdiff(tu)           -> te

} else {
  tr <- tu <- te <- seq_len(nobs)
}

# Note the actual target values and the risk values.

ds %>% slice(tr) %>% pull(target) -> actual_tr
ds %>% slice(tu) %>% pull(target) -> actual_tu
ds %>% slice(te) %>% pull(target) -> actual_te
  
if (!is.null(risk))
{
  ds %>% slice(tr) %>% pull(risk) -> risk_tr
  ds %>% slice(tu) %>% pull(risk) -> risk_tu
  ds %>% slice(te) %>% pull(risk) -> risk_te
}
