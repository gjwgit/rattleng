# Rattle Script to prepare a dataset
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-09-28 08:34:06 +1000 Graham Williams>
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

# Run this after the variable `ds` (dataset) has been loaded into
# Rattle.  This script will then clean and prepare the dataset. The
# following action is the dataset template processing. We place into
# `dataset_template.R` the setup when the data within the dataset has
# changed, which may be called again after, for example, TRANSFORM.
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

# 20240809 gjw Move main.R here to avoid the problem on Windows where
# main.R is not getting run.

# We begin most scripts by loading the required packages.  Here are
# some initial packages to load and others will be identified as we
# proceed through the script. When writing our own scripts we often
# collect together the library commands at the beginning of the script
# here.

library(dplyr)
library(janitor)
library(magrittr)

# Normalise the variable names using janitor::clean_names(). This is
# done after any dataset load. The DATASET tab has an option to
# normalise the variable names on loading the data. It is set on by
# default.

if (NORMALISE_NAMES) ds %<>% janitor::clean_names(numerals="right")

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

# Check for unique valued columns.

unique_columns(ds)

# Find fewest levels

find_fewest_levels(ds)


# Index the original variable names by the new names.

names(vnames) <- names(ds)

# Display the list of vars.

names(ds)

# 20240916 gjw This is required for building the ROLES table but will
# eventually be replaced by the meta data.

glimpse(ds)
summary(ds)

# Filter the variables in the dataset that are factors or ordered factors with more than 20 levels.

large_factors <- sapply(ds, is_large_factor)

# Get the names of those variables.

large_factor_vars <- names(large_factors)[large_factors]

# Print the variable names.

large_factor_vars
