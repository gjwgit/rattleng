# Rattle Scripts: Prepare dataset for the template: normalise, clean.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-07-23 19:29:27 +1000 Graham Williams>
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

# Run this after the variable `ds` (dataset) has been instantiated.
# This script will prepare the dataset for template variable processing.
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

# Capture the original variable names for use in plots.

vnames <- names(ds)

# Normalise the variable names using janitor::clean_names(). This is
# done after any dataset load. The DATASET tab has an option to
# normalise the variable names on loading the data. It is set on by
# default.

if (NORMALISE_NAMES) ds %<>% clean_names(numerals="right")

# Cleanse the dataset of constant value columns and convert char to
# factor.

if (CLEANSE_DATASET) {
  # Map character columns to be factors.
  
  ds %<>% mutate_if(sapply(ds, is.character), as.factor)

  # Remove any constant columns,

  ds %<>% remove_constant()
}

# Check for unique valued columns.

# First  check if values in a column are unique.

check_unique <- function(x) {
  !any(duplicated(x))
}

# Then find columns with unique values.

unique_columns <- function(df) {
  col_names <- names(df)
  unique_cols <- col_names[sapply(df, check_unique)]
  return(unique_cols)
}

# Usage

unique_columns(ds)


# Index the original variable names by the new names.

names(vnames) <- names(ds)

# Display the list of vars.

names(ds)

