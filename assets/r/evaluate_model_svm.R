# Define `pred_ra` and `prob_ra` for a svm model.
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2025-01-14 15:43:44 +1100 Graham Williams>
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
# Author: Zheyuan Xu, Graham Williams

# Rattle timestamp: <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# 20241220 gjw Save the model to the <TEMPLATE> variable `model`. This
# will be used below and in the following evaluations as required.

model <- model_svm

# 20250105 zy Redefine the model type to update the output of error
# matrix.

mtype <- "svm"
mdesc <- "Support Vector Machine"

# 20250101 gjw Define the template functions to generate the
# predications and the probabilities.

pred_ra <- function(model, data){
  
  # Impute missing values in the input dataset using the mice package.
  # 'm = 1' generates one complete dataset; other missing data handling methods can be specified in `method`.

  tuds_imputed <- complete(mice(data, m = 1))
  predict(model, newdata=tuds_imputed,)
}

prob_ra <- function(model, data){

  # Impute missing values in the input dataset using the mice package.
  # 'm = 1' generates one complete dataset; other missing data handling methods can be specified in `method`.
  
  tuds_imputed <- complete(mice(data, m = 1))
  predict(model, newdata=data, type="prob")[,2]
} 
