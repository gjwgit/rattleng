# Setup the model template variables for descriptive and predictive models.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-01-22 21:07:03 +1100 Graham Williams>
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

# <TIMESTAMP>
#
# Run this script after the variable `ds` (dataset) and other data
# template variables have been defined as in `data_template.R`. This
# script will initialise the model template variables including
# performing any partitioning.
#
# References:
#
# @williams:2017:essentials Chapter 7.
#
# https://survivor.togaware.com/datascience/model-template.html

# Load required packages from the local library into the R session.

library(stringi)      # The string concat operator %s+%.

# Record basic variable roles for the templates.

ignore <- c(risk, id, <IGNORE_VARS>)
vars   <- setdiff(vars, ignore)
inputs <- setdiff(vars, target)

# Generate the formula to be used for predictive modelling which is
# available when a <TARGET> variable is identified.

if (!is.null(target)) {
  form <- formula(target %s+% " ~ .")

  # 20250108 gjw Create the <TARGET> <COMPLETE> dataset (tcds).  We
  # identify a subset of the FULL <DATASET> that has values for the
  # target variable, removing those rows that do not have a
  # target. For predictive modelling we would only use data that has a
  # target value.

  # 20250115 gjw Note that this is different to the default for V5
  # which leaves the missing targets in the dataset.

  tcds <- ds[!is.na(ds[[target]]),]
} else {
  form <- formula("~ .")

  # If no <TARGET> variable is identified then we still want to start
  # with a `tcds` for processing.

  tcds <- ds
}

# parrty::ctree() cannot handle predictors of type character.  Convert
# character columns to factors. 20250116 gjw This may not be the case
# with the newer partykit package. Try not for now.

# tcds <- tcds %>%
#   mutate(across(where(is.character), as.factor))

print(form)

# Update the number of `obs` which is needed for the partitioning.

tcnobs <- nrow(tcds)

if (<SPLIT_DATASET>) {

  # Split the dataset into train, tune, and test, recording the indicies
  # of the observations to be associated with each dataset. If the
  # dataset is not to be partitioned, simply have the train, tune and
  # test datasets as the whole dataset.

  # To get the same model each time we partitin the dataset the same
  # way each time based on a fixed seed that the user can override to
  # explore the impact of different dataset paritioning on the
  # resulting model.

  # TODO 20241202 gjw <REPLACE> THE <FIXED> 42 WITH A <SETTINGS> <VALUE> FOR THE SEED.

  # TODO 20241202 gjw ADD <PROVIDER> FOR <RANDOM_PARTITION> TO <RANDOMISE> EACH TIME.

  # TODO 20241202 gjw <MAYBE> IF <RANDOM_SEED> IS <EMPTY> WE <RANDOMISE> EACH TIME HERE.

  if (! <RANDOM_PARTITION>) {
    set.seed(<RANDOM_SEED>)
  }

  # Specify the three way split for the dataset: <TRAINING> (tr) and
  # <TUNING> (tu) and <TESTING> (te).

  split <- c(<DATA_SPLIT_TR_TU_TE>)

  # 20250122 gjw Build the indicies for the different datasets:
  # complete, train, tune, and test.

  tc <- 1:tcnobs
  tr <- tcnobs %>% sample(split[1]*tcnobs)
  tu <- tcnobs %>% seq_len() %>% setdiff(tr) %>% sample(split[2]*tcnobs)
  te <- tcnobs %>% seq_len() %>% setdiff(tr) %>% setdiff(tu)

} else {

  # If the user has decided not to partition the data we will build
  # the model and tune/test the model on the same dataset. This is not
  # good practice as the tuning and testing will deliver very
  # optimistic estimates of the model performance.

  tc <- tr <- tu <- te <- 1:tcnobs
}

# Note the actual values of the <TARGET> variable and the RISK variable
# for use in model training and evaluation later on.

if (!is.null(target)) {
  actual_tc <- tcds %>% dplyr::slice(tc) %>% pull(target)
  actual_tr <- tcds %>% dplyr::slice(tr) %>% pull(target)
  actual_tu <- tcds %>% dplyr::slice(tu) %>% pull(target)
  actual_te <- tcds %>% dplyr::slice(te) %>% pull(target)
}

if (!is.null(risk)) {
  risk_tc <- tcds %>% dplyr::slice(tc) %>% pull(risk)
  risk_tr <- tcds %>% dplyr::slice(tr) %>% pull(risk)
  risk_tu <- tcds %>% dplyr::slice(tu) %>% pull(risk)
  risk_te <- tcds %>% dplyr::slice(te) %>% pull(risk)
}

# Retain only the columns that we need for the predictive modelling.
# ctree() from the party package cannot handle predictors of type
# character so convert character columns to factors.  The aim is to
# ensure feature names stored in `object` and `newdata` are the same.

tcds <- tcds[tc, setdiff(vars, ignore)] %>%
  mutate(across(where(is.character), as.factor))

trds <- tcds[tr, setdiff(vars, ignore)] %>%
  mutate(across(where(is.character), as.factor))

tuds <- tcds[tu, setdiff(vars, ignore)] %>%
  mutate(across(where(is.character), as.factor))

teds <- tcds[te, setdiff(vars, ignore)] %>%
  mutate(across(where(is.character), as.factor))

# TODO 20250122 gjw REVIEW WHY IT IS NEEDED AND EXPLAIN IT.

if (!is.null(target)) {

  # Convert to numeric (binary if applicable).

  levels_actual <- unique(actual_tc)
  actual_numeric_tc <- ifelse(actual_tc == levels_actual[1], 0, 1)

} else {
  # If no target, set `actual_tc` to NULL.

  actual_tc <- NULL
  actual_numeric_tc <- NULL
}

# Check if the risk variable exists and create `risk_tc`.

if (!is.null(risk)) {
  # Retrieve the risk values for the full dataset.

  risk_tc <- tcds %>%
    pull(risk) %>%
    as.numeric()  # Ensure it's numeric.

  # 20250108 gjw We used to handle NA risk values by replacing them
  # with a default value (e.g., 0). For now let's not do that.

  risk_tc <- ifelse(is.na(risk_tc) | is.nan(risk_tc), 0, risk_tc)
} else {
  # If no risk, set `risk_tc` to NULL.

  risk_tc <- NULL
}
