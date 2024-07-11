# Rattle Scripts: For dataset ds geneate missing analysis.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2024-07-12 09:36:41 +1000 Graham Williams>
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

# Summary of missing in the dataset
#
# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# The 'mice' package provides the 'md.pattern' function.

library(mice, quietly=TRUE)

# Generate a summary of the missing values in the dataset.

vars_na <- names(ds)[sapply(ds, anyNA)]

svg("TEMPDIR/explore_summary.svg")

md.pattern(ds[vars_na])

dev.off()

# install.packages("VIM")

library(VIM)

# Aggregate plot of missing values

svg("TEMPDIR/explore_missing_vim.svg", width=14)
aggr(ds, numbers=TRUE, sortVars=TRUE, labels=names(ds),
     cex.axis = .7, gap = 3, ylab = c("Missing data", "Pattern"))
dev.off()

## # TODO
## install.packages("naniar")
## library(naniar)
## # Visualize the proportion of missing values in each variable
## gg_miss_var(ds)

## # Visualize a heatmap of missing values
## vis_miss(ds)

## # Visualize missing data using an UpSet plot
## gg_miss_upset(ds)


