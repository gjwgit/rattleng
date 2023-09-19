# Rattle Scripts: Load Rattle's default weather demo dataset. 
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2023-09-20 05:01:04 +1000 Graham Williams>
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

# Initialise the dataset as per the templates.
#
# Rattle timestamp: <<TIMESTAMP>>
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

# The `r Rdataset(weatherAUS)` dataset is loaded into the template
# variable `ds` and further template variables are initialised.

weatherAUS <- rattle::weather # Ensure we have the original version.

dsname <- "weather"

ds     <- get(dsname)

# Capture the original variable names if later required.

vnames <- names(ds)

<<BEGIN_NORMALISE_NAMES>>
#
# Normalise the variable names using janitor::clean_names(). This is
# done on the dataset load and the DATA tab has an option to normalise
# the variable names on loading the data. It is set on by default.

ds    %<>% clean_names(numerals="right")

<<END_NORMALISE_NAMES>>

# Index the original variable names by the new names.

names(vnames) <- names(ds)
