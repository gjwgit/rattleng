# Load a CSV file into the session as `ds`.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-11-28 13:57:42 +1100 Graham Williams>
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

# The file `FILENAME` is loaded as a CSV file into the template
# variable `ds` (dataset), intialising the `dsname` (a printable name
# for the dataset) and `vnames` (the variable names).
#
# TIMESTAMP
#
# The data contained in the file `FILENAME`
# is loaded as a CSV file into the template variable `ds` (dataset),
# intialising the `dsname` (a printable name for the dataset) and
# `vnames` (the variable names).
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/csv-data-reading.html

library(magrittr)
library(readr)        # Read/write delimited data: read_csv().

dsname <- "FILENAME" %>% basename() %>% sub(".csv$", "", .)

assign(dsname, readr::read_csv("FILENAME"))

ds <- get(dsname)

# Capture the original variable names for use in plots.

vnames <- names(ds)

vnames
