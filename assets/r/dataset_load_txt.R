# Rattle Scripts: Load a text file into the session as `txt`.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-11-23 10:03:01 +1100 Graham Williams>
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

# The file `<FILENAME>` is loaded as a CSV file into the template
# variable `ds` (dataset), intialising the `dsname` (a printable name
# for the dataset) and `vnames` (the variable names).
#
# Rattle timestamp: <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/csv-data-reading.html

library(magrittr)        # Pipeline: %>%

dsname <- "<FILENAME>" %>% basename() %>% sub(".txt$", "", .)

txt <- readLines("<FILENAME>")

cat(txt, sep = "\n")
