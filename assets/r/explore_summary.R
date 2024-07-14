# Rattle Scripts: For dataset ds generate summary statistics.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-14 06:10:14 +1000 Graham Williams>
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
# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# The 'Hmisc' package provides the 'contents' function.

library(Hmisc, quietly=TRUE)

# Obtain a summary of the dataset.

contents(ds)

# Standard R summary of the dataset.

summary(ds)

# Generate a description of the dataset.

describe(ds)

# The 'basicStats' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Generate a description of the numeric data.

lapply(ds[numc], basicStats)

# The 'kurtosis' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Summarise the kurtosis of the numeric data.

kurtosis(ds[numc], na.rm=TRUE)

# The 'skewness' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Summarise the skewness of the numeric data.

skewness(ds[numc], na.rm=TRUE)

# The 'CrossTable' package provides the 'descr' function. Needs work
# to make it useful in RattleNG.

library(descr, quietly=TRUE)

# Generate cross tabulations for categoric data.

for (i in catc) { 
  cat(sprintf("CrossTab of %s by target variable %s\n\n", i, target)) 
  print(CrossTable(ds[[i]], ds[[target]], expected=TRUE, format="SAS")) 
  cat(paste(rep("=", 70), collapse=""), "

") 
}
