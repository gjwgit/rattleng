# After loading the raw dataset we prepare it for ROLES.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-11-28 14:00:50 +1100 Graham Williams>
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
# Run this after the raw dataset has been loaded into the variable
# `ds` in R and before the R data template script is run (on leaving
# the DATASET tab).  This script cleans and prepares the dataset
# according to any configured cleaning and needs to do this before we
# run the template script. After the cleaning we generate the META
# DATA to be scraped for the ROLES display. The `dataset_template.R`
# script will be run after the data within the dataset has been
# prepared, which may be called again after, for example, a TRANSFORM.
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

library(dplyr)        # Wrangling: select() sample_frac().
library(janitor)      # Cleanup: clean_names().
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().

# Normalise the variable names using janitor::clean_names(). This is
# done after any dataset load. The DATASET tab has an option to
# normalise the variable names on loading the data. It is set on by
# default.

if (NORMALISE_NAMES) {
  ds %<>% janitor::clean_names(numerals="right")

  # TODO 20241008 gjw MIGRATE TO META DATA

  # Index the original variable names by the new names.

  names(vnames) <- names(ds)
}

# Cleanse the dataset of constant value columns and convert char to
# factor.

if (CLEANSE_DATASET) {
  # Map character columns to be factors.
  
  ds %<>% mutate(across(where(is.character),
                        ~ if (n_distinct(.) <= MAXFACTOR)
                          as.factor(.) else .))

  # Remove any constant columns,

  ds %<>% remove_constant()

  # Check if the last variable is numeric and has 5 or fewer unique
  # values then treat it as a factor since it is probably a target
  # variable. This is a little risky but perhaps worth doing. It may
  # need it's own toggle.

  # Get the name of the last column

  last_col_name <- names(ds)[ncol(ds)]

  # Check if the last column is numeric and has 5 or fewer unique values

  if (is.numeric(ds[[last_col_name]]) && length(unique(ds[[last_col_name]])) <= 5) {
    ds[[last_col_name]] <- as.factor(ds[[last_col_name]])
  }

}

# 20241008 gjw We can now generate the meta data for the dataset. This
# will be scraped into the metaProvider by the DATASET DISPLAY and
# will be the definitive meta data for the dataset, replacing the
# roles and types providers and many of the below informational
# queries.

meta_data(ds)

# TODO 20241008 gjw MIGRATE TO META DATA

# Check for unique valued columns. This will be scraped and used in
# assigning a ROLE of IDENT to the variables

unique_columns(ds)

# TODO 20241008 gjw MIGRATE TO META DATA

# List the variables having the fewest levels. This will be scraped
# and used in identifying the TARGET varaible.

find_fewest_levels(ds)

# Display the list of vars.

names(ds)

# TODO 20241008 gjw MIGRATE TO META DATA

# 20240916 gjw The glimpse is required for building the ROLES table but will
# eventually be replaced by the meta data. Keep here for now.

glimpse(ds)
#summary(ds)

# TODO 20241008 gjw MIGRATE TO META DATA

# Filter the variables in the dataset that are factors or ordered
# factors with more than 20 levels. This should be replaced by using
# the meta data.

large_factors <- sapply(ds, is_large_factor)

# Get the names of those variables.

large_factor_vars <- names(large_factors)[large_factors]

# Print the variable names.

large_factor_vars
