# Rattle Scripts: Load a CSV file into the session as `ds`.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2023-09-13 15:05:12 +1000 Graham Williams>
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

# Given a FILENAME we load it as a CSV file into the template variable
# `ds` (dataset) as per the templates introduced in
# @williams:2017:essentials.
#
# Also see
# https://survivor.togaware.com/datascience/csv-data-reading.html


print("TODO READ CSV FROM <<FILENAME>>")

<<BEGIN_NORMALISE_NAMES>>
#
# Normalise the variable names using janitor::clean_names(). This is
# done on the dataset load and the DATA tab has an option to normalise
# the variable names on loading the data. It is set on by default.

ds    %<>% clean_names(numerals="right")

<<END_NORMALISE_NAMES>>
