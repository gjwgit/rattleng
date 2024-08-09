# Rattle Scripts: Setup the data template variables.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-08-03 14:37:53 +1000 Graham Williams>
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

# Run this after the variable `ds` (dataset) has been loaded and
# prep'd or changed in some way, as after a TRANSFORM session.  This
# script will initialise or update the data template variables.
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

target <- "TARGET_VAR"
risk   <- "RISK_VAR"
id     <- c(ID_VARS)

# Record the number of observations.

nobs   <- nrow(ds)

# Note the variable names.

vars   <- names(ds)

# Make the target variable the last one.

vars   <- c(target, vars) %>% unique() %>% rev()

# Identify the input variables for modelling.

inputs <- setdiff(vars, target) %T>% print()

# Also record them by indicies.

inputs %>%
  sapply(function(x) which(x == names(ds)), USE.NAMES=FALSE) %T>%
  print() ->
inputi

# Identify the numeric variables by index.

ds %>%
  sapply(is.numeric) %>%
  which() %>%
  intersect(inputi) %T>%
  print() ->
numi

# Identify the numeric variables by name.

ds %>% 
  names() %>% 
  magrittr::extract(numi) %T>% 
  print() ->
numc

# Identify the categoric variables by index.

ds %>%
  sapply(is.factor) %>%
  which() %>%
  intersect(inputi) %T>%
  print() ->
cati

# Identify the categoric variables by name.

ds %>% 
  names() %>% 
  magrittr::extract(cati) %T>% 
  print() ->
catc

# Identify variables by name that have missing values.

missing <- colnames(ds)[colSums(is.na(ds)) > 0]

missing

# Identify the number of rows with missing values.

missing_rows <- sum(apply(ds, 1, anyNA))

missing_rows

glimpse(ds)
summary(ds)
