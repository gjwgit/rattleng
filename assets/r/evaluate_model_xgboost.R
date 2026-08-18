# Define `pred_ra` and `prob_ra` for a xgboost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2025-05-05 12:09:06 +1000 Graham Williams>
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
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/ for further details.

model <- model_xgb

# Redefine the model type to update the output of error matrix. (zy
# 20250105)

mtype <- "xgboost"
mdesc <- "Extreme Boost"

# Define the template functions to generate the predications and the
# probabilities for a given dataset. (gjw 20250101)

pred_ra <- function(model, data) {

  # 20260818 gjw The classes come from `xgb_levels`, remembered when the model
  # was built, rather than from `data[[target]]`. The data is not always the
  # training data and does not always have a target column at all: an
  # interactive prediction supplies just the inputs, and so may a dataset
  # loaded on EVALUATE, and there the levels were read from nothing and every
  # prediction came back missing.

  pr <- factor(ifelse(xgb_predict(model, data) > 0.5,
                      xgb_levels[2],
                      xgb_levels[1]),
               levels=xgb_levels)

  return(pr)
}
##
## # Retrieve the vector of possible target levels from the data.
##
## target_levels <- unique(data[[target]]) # nolint as sourced from 'model_template.R'
##
## # Check if target_levels is either c("1", "0") or c("0", "1")
## # to avoid reversed results.
## #
## # Why was this needed? (gjw 20250324)
##
## if (all(target_levels %in% c("1", "0"))) {
##   # Sort target levels to ensure "0" comes before "1".
##
##   target_levels <- sort(target_levels)
## }
##
## # Get raw numeric probabilities (assuming the model returns a single column
## # or you've already extracted the relevant column.
##
## prob_vec <- predict(model, newdata=data, type="prob")
##
## # Map probabilities to factor levels.
## # - If the probability is NA, set the label to NA.
## # - If the probability > 0.5, pick target_levels[2].
## # - Otherwise, pick target_levels[1].
## # We immediately convert to character so the ifelse() doesn't
## # accidentally coerce things back to numeric.
## #
## # THIS WAS PLAIN WRONG for the audit dataset on testing. I had to
## # swap the indicies 1 and 2 here to get the correct results. The
## # explanation in the code here is simply not good enough to
## # understand why Zheyuan chose this approch. (gjw 20250324)
##
## mapped_values_char <- ifelse(
##   is.na(prob_vec),
##   NA_character_,
##   ifelse(prob_vec > 0.5,
##          as.character(target_levels[2]),
##          as.character(target_levels[1]))
## )
##
## # Convert the character vector to a factor with the same levels as 'target_levels'.
## # This ensures the output is not numeric, but a factor with consistent levels.
##
## mapped_values_factor <- factor(mapped_values_char, levels = target_levels)
##
## # Return the factor vector.
##
## return(mapped_values_factor)
## }
prob_ra <- function(model, data) xgb_predict(model, data)
