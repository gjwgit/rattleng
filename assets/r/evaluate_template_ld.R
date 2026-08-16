# Apply the `model` to the loaded dataset `evalds`.
#
# Copyright (C) 2026, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2026-08-16 11:05:00 +1000 Graham Williams>
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

# Rattle timestamp: <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

## #########################################################################
## 20260816 gjw The counterpart of evaluate_template_tc.R and friends for
## a dataset loaded from its own file by evaluate_load_dataset.R, rather
## than a partition of the dataset the model was built from. It reports
## the same four variables that every evaluation measure works from.
## #########################################################################

dtype <- 'loaded'

actual_va      <- actual_ld
risk_va        <- risk_ld

predicted   <- pred_ra(model, evalds)
probability <- prob_ra(model, evalds)
