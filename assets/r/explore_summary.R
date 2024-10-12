# Generate summary statistics for the dataset.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-10-12 20:40:19 +1100 Graham Williams>
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

# Various summaries that are provided by R and different pacakges are
# generated to obtain some insight into the dataset we are looking at.
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials
# https://survivor.togaware.com/datascience/ for further details.

library(descr)
library(skimr)

# SkimR presents a nice summary of the dataset

skim(ds)

# Standard R summary of the dataset.

summary(ds)

# Obtain a summary of the dataset. 20240815 gjw Does not add any new
# information.

## Hmisc::contents(ds)

# Generate a description of the dataset. 20240815 gjw Does not add any
# new information.

## Hmisc::describe(ds)

# Generate a description of the numeric data. 20240815 gjw Does not
# add any new information.

## lapply(ds[numc], fBasics::basicStats)

# Summarise the kurtosis of the numeric data.

timeDate::kurtosis(ds[numc], na.rm=TRUE)

# Summarise the skewness of the numeric data.

timeDate::skewness(ds[numc], na.rm=TRUE)

# Generate cross tabulations for categoric data. 20240815 gjw This is
# qite costly, and memory hungry, for a 20,000 observation dataset so
# by default we do not build the cross tabulation. 

if (SUMMARY_CROSS_TAB) {
  for (i in catc) {
    cat(sprintf("CrossTab of %s by target variable %s\n\n", i, target))
    print(descr::CrossTable(ds[[i]], ds[[target]], expected=TRUE, format="SAS"))
    cat(paste(rep("=", 70), collapse=""), "\n")
  }
} else {
  cat("\n") 
}

