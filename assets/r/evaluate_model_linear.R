# Define `pred_ra` and `prob_ra` for a linear model.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-03-05 17:34:54 +1100 Graham Williams>
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
# Author: Zheyuan Xu

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/ for further details.

# 20241220 gjw Save the model to the TEMPLATE variable `model`. This
# will be used below and in the following evaluations as required.

model <- model_glm

# 20250305 gjw Specify the model type and the model description.

mtype <- "linear"
mdesc <- "Linear Model"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities.
##
## Rattle V5 does this:
##
## crs$pr <- as.vector(ifelse(predict(crs$glm,
##   type    = "response",
##   newdata = crs$dataset[crs$validate, c(crs$input, crs$target)]) > 0.5, "Yes", "No"))
##
## 20250305 gjw This is hard wiring Yes and No. Need to get the actual
## dataset classes.
##
## 20250305 gjw Currently I am getting an EXTRA LEVELS error
##
##   factor wind_dir_9am has new levels SW, WNW

pred_ra <- function(model, data) as.vector(ifelse(predict(model,
                                                          type    = "response",
                                                          newdata = data) > 0.5,
                                                  "Yes", "No"))

prob_ra <- function(model, data) predict(model,
                                         type    = "response",
                                         newdata = data)
