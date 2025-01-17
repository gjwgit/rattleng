# Rattle Scripts: Data Transformation/Wrangling
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2024-08-19 08:47:08 +1000 Graham Williams>
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
# Author: Kevin Wang




# Remap variables. 

# Transform into a factor.

ds[["<TFC_SELECTED_VAR>"]] <- as.factor(ds[["<SELECTED_VAR>"]])

ol <- levels(ds[["<TFC_SELECTED_VAR>"]])
lol <- length(ol)
nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
levels(ds[["<TFC_SELECTED_VAR>"]]) <- nl

#=======================================================================
#=======================================================================
glimpse(ds)
summary(ds)
