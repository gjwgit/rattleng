# Apply the `model` to the full dataset `tcds`.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2024-12-20 20:46:22 +1100 Graham Williams>
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
# Author: Graham Williams, Zheyuan Xu

# Rattle timestamp: TIMESTAMP
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
## 20241220 gjw DO NOT MODIFY THIS FILE WITHOUT DISCUSSION
## #########################################################################
## #########################################################################
## #########################################################################

########################################################################

# Identify the dataset partition that the model is applied to.
##
## TODO 20241220 THIS NEEDS TO TOGGLE full OR validation.

dtype <- 'full'

# Store into the TEMPLATE variables the corresponding predicted,
# actual and risk values for later processing.

actual      <- actual_tf
predicted   <- pred_tf
probability <- prob_tf
risk        <- risk_tf
