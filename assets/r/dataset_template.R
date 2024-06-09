# Rattle Scripts: Setup the data template variables.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-06-09 12:42:03 +1000 Graham Williams>
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
# This script will initialise the data template variables.
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

# PREREQUISITE
#
# This is expected to be completed after a dataset_load and then the
# dataset_prep.

# Identify variable roles.

target <- "VAR_TARGET"
risk   <- "VAR_RISK"
id     <- c(VARS_ID)

# Record the number of observations.

nobs   <- nrow(ds)

# Note the variable names.

vars   <- names(ds)

# Make the target variable the last one.

vars   <- c(target, vars) %>% unique() %>% rev()

# Identify the numeric variables


vars %>%
  magrittr::extract(ds, .) %>%
  sapply(is.numeric) %>% 
  which() %>%
  names() %T>%
  print() ->
numc


