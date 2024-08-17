# Rattle Scripts: For dataset ds generate summary statistics.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-08-15 19:20:36 +1000 Graham Williams>
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

# Summary of a Dataset
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials
# https://survivor.togaware.com/datascience/ for further details.

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
# too costly, and memory hungry, for a 20,000 observation dataset so
# drop for now.

## for (i in catc) { 
##   cat(sprintf("CrossTab of %s by target variable %s\n\n", i, target)) 
##   print(descr::CrossTable(ds[[i]], ds[[target]], expected=TRUE, format="SAS")) 
##   cat(paste(rep("=", 70), collapse=""), "

## ") 
## }
