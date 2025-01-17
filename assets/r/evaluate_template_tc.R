# Apply the `model` to the complete dataset `tcds`.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-01-01 21:00:49 +1100 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but <WITHOUT>
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Graham Williams, Zheyuan Xu

# Rattle timestamp: <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

## #########################################################################
## #########################################################################
## #########################################################################
## 20241220 gjw DO NOT <MODIFY> THIS FILE <WITHOUT> <DISCUSSION>
## #########################################################################
## #########################################################################
## #########################################################################

####################################

# Identify the dataset partition that the model is applied to.

dtype <- 'complete'

# Store in <TEMPLATE> variables the actual and risk values, and the
# predicted and probabilites, for later processing.

actual      <- actual_tc
risk        <- risk_tc

predicted   <- pred_ra(model, tcds)
probability <- prob_ra(model, tcds)
