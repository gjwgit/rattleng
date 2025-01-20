# Rattle Scripts: Data Transformation/Wrangling
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-10-08 09:13:28 +1100 Graham Williams>
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

# Transform "<SELECTED_VAR>" by replacing NA with the mean value.

library(dplyr)        # Wrangling: mutate().

if (is.numeric(ds$<SELECTED_VAR>))
{
  ds %<>%
    mutate(IMN_<SELECTED_VAR> = ifelse(is.na(<SELECTED_VAR>),
                                     mean(<SELECTED_VAR>, na.rm = TRUE),
                                     <SELECTED_VAR>))
}

glimpse(ds)
summary(ds)
