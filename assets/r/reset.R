# Rattle Scripts: Reset the data variables.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-09-04 08:38:19 +1000 Graham Williams>
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

vnames <- names(ds)

unique_columns <- function(df) {
  col_names <- names(df)
  unique_cols <- col_names[sapply(df, check_unique)]
  return(unique_cols)
}

unique_columns(ds)

names(vnames) <- names(ds)

names(ds)

glimpse(ds)
summary(ds)

# Check if a variable is a factor (including ordered factors) and has more than 10 levels.

is_large_factor <- function(x) {
  is.factor(x) || is.ordered(x) && length(levels(x)) > 10
}

# Filter the variables in the dataset that are factors or ordered factors with more than 10 levels.

large_factors <- sapply(ds, function(x) {
  if (is.factor(x) || is.ordered(x)) {
    return(length(levels(x)) > 10)
  }
  return(FALSE)
})

# Get the names of those variables.

large_factor_vars <- names(large_factors)[large_factors]

# Print the variable names.

large_factor_vars
