# Rattle Scripts: Dataset template variables are initialised after dataset prep.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-12-12 16:31:27 +1100 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but <WITHOUT>
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Graham Williams, Yixiang Yin

# <TIMESTAMP>
#
# Run this after the variable `ds` (dataset) has been loaded into
# Rattle and the dataset cleansed and prepared with roles
# assigned. The actions here in `dataset_template.R` will also setup
# the data after a dataset has changed, which may be called after, for
# example, a <TRANSFORM>.
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

library(dplyr)        # Wrangling: select() sample_frac().
library(janitor)      # Cleanup: clean_names().
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().

## # Index the original variable names by the new names.
##
## names(vnames) <- names(ds)
##
## # Display the list of vars.
##
## names(ds)

# Filter the variables in the dataset that are factors or ordered
# factors with more than 20 levels.

large_factors <- sapply(ds, is_large_factor)

# Get the names of those variables.

large_factor_vars <- names(large_factors)[large_factors]

# Print the variable names.

large_factor_vars

# Identify variable roles.

target <- "<TARGET_VAR>"
ident  <- "<IDENT_VAR>"
risk   <- "<RISK_VAR>"
id     <- c(<ID_VARS>)

# Identify variables to ignore.

ignore <- <IGNORE_VARS>

## 20240829 gjw Ideally remove the ignored variables from ds for now as
## a bug fix to support the <CORRELATION> feature for selected
## variables. In future this dataset template will reload the dataset
## into ds from `get(dsname)` each time it is run afresh. FOR NOW do
## this for <CORRELATION> only.
##
## ds <- ds[setdiff(names(ds), ignore)]
##
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

nmobs <- sum(apply(ds, 1, anyNA))

nmobs

## # 20240916 gjw This is required for building the <ROLES> table but will
## # eventually be replaced by the meta data.
##
## # 20241008 gjw I don't think these are required here now.
##
## # glimpse(ds)
## # summary(ds)
##
## # 20240814 gjw migrate to generating the meta data with rattle::meta_data(ds)
##
## # 20241008 gjw I think we now move this to PREP rather than
## # here. 20241212 gjw However this is required to update the <DATASET>
## # view of the data, particularly after a <TRANSFORM>. So add it back in
## # here. Without this the <DATASET> will not show that an imputed
## # IMN_rainfull, for example, has 54 unique values (it is 0 when
## # IMN_rainfall does not appear in metaData).

# Report on the meta data for `ds`.

meta_data(ds)
##
## # Filter the variables in the dataset that are factors or ordered
## # factors with more than 20 levels.
##
## # large_factors <- sapply(ds, is_large_factor)
##
## # Get the names of those variables.
##
## # large_factor_vars <- names(large_factors)[large_factors]
##
## # Print the variable names.
##
## # large_factor_vars
