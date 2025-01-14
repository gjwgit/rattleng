# Using `actual` and `predicted` generate error matrix.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 16:16:05 +1100 Graham Williams>
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
# Author: Zheyuan Xu, Graham Williams

# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(rattle)       # Generate an error matrix.

em_count <- rattle::errorMatrix(actual, predicted, count=TRUE)
##
## 20241229 zy Capture the output of the error matrix and print it to
## the console.  The print line includes '> ` for the dart script to
## identify the error matrix. 20250106 gjw Use `rat()` rather than
## `cat()` to avoid exposing the command to the user's exported
## script.
##
rat(paste('> ', mtype, "_DATASET_TYPE_COUNT ", sep=""))
em_count

# Generate a confusion matrix with proportions (relative frequencies)
# rather than counts.

em_prop <- rattle::errorMatrix(actual, predicted)
##
## 20241229 zy Capture the output of the error matrix and print it to
## the console.  The print line includes '> ` for the dart script to
## identify the error matrix. 20250106 gjw Use `rat()` rather than
## `cat()` to avoid exposing the command to the user's exported
## script.
##
rat(paste('> ', mtype, "_DATASET_TYPE_PROP ", sep = ""))
em_prop
