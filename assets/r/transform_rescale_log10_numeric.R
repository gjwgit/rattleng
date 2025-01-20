# Rattle Scripts: Data Transformation/Wrangling
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-07-30 13:48:01 +1000 Graham Williams>
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

# Transform "<SELECTED_VAR>" into "R10<_SELETED_VAR>" by applying log10().
# Treat -Inf as NA.

ds %<>%
  mutate(R10_<SELECTED_VAR> = log10(<SELECTED_VAR>),
         R10_<SELECTED_VAR> = ifelse(is.infinite(R10_<SELECTED_VAR>),
                                   NA, R10_<SELECTED_VAR>))

glimpse(ds)
summary(ds)
