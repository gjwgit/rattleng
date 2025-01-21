# Rattle Scripts: Missing Analysis.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-08-29 17:26:43 +0800 Graham Williams>
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

# Summary of <MISSING> in the dataset.
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials
#
# https://survivor.togaware.com/datascience/

# TODO 20240829 gjw TEMP FIX FOR <IGNORE> <HANDLING>

tds <- ds[setdiff(vars,ignore)]

####################################
## MICE :: MD.<PATTERNS>
####################################

# Generate a summary of the missing values in the dataset. 20240718

svg("<TEMPDIR>/explore_missing_mice.svg")
mice::md.pattern(tds, rotate.names=TRUE)
dev.off()

####################################
## VIM :: <AGGREGATION>
####################################

svg("<TEMPDIR>/explore_missing_vim.svg", width=16)
VIM::aggr(tds,
          bars  = TRUE,
          numbers=TRUE,
          prop=FALSE,
          combined=FALSE,
          varheight=FALSE,
          only.miss=TRUE,
          border='white',
          sortVars=TRUE,
          sortCombs=TRUE,
          labels=names(tds),
          cex.axis = .6,
          gap      = 3,
          ylabs     = c("Proportion of Values Missing",
                        "Proportions of Combinations of Missing Values"))
dev.off()

####################################
## <NANIAR>
####################################

# Visualize a heatmap of missing values

svg("<TEMPDIR>/explore_missing_naniar_vismiss.svg", width=16)
tds %>%
  naniar::vis_miss()
dev.off()

# 20240815 gjw Visualize the proportion of missing values in each
# variable. We could add a configuration here to display percentages
# rather than counts. `show_pct=TRUE`

svg("<TEMPDIR>/explore_missing_naniar_ggmissvar.svg", width=16)
naniar::gg_miss_var(tds)
dev.off()

# Visualize missing data using an UpSet plot

svg("<TEMPDIR>/explore_missing_naniar_ggmissupset.svg", width=16)
naniar::gg_miss_upset(tds)
dev.off()
