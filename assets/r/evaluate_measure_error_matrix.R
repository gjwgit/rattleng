# Using `actual` and `predicted` values generate two error matrices.
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-04-04 13:52:06 +1100 Graham Williams>
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

# After a model is built we want to evaluate its performance. The
# error matrix is a traditional way to do so. Here we generate two
# matrices, one is the raw count of hte predictions and the other is
# the percentages.
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# Add a check to ensure that the actual and predicted have the same
# levels. To avoid every pred_ra function to do this check, we do it
# here. (zy 20250108)
#
# We combine the levels from both vectors, sort them if you want a
# consistent order, and then use the levels for both variables.

all_levels <- union(levels(actual_va), levels(predicted))
all_levels <- sort(all_levels)
actual_va  <- factor(actual_va, levels=all_levels)
predicted  <- factor(predicted, levels=all_levels)

# Next we build the error matrices.

em_count <- rattle::errorMatrix(actual_va, predicted, count=TRUE)
em_prop  <- rattle::errorMatrix(actual_va, predicted)

## BEGIN RATTLE ONLY
#
# We process the error matrix into a string primarily for the benefit
# of Rattle, and then write out a particular string to more easily
# scrape the results from R into Rattle.

em_count_str <- capture.output(print(em_count))
writeLines(paste0('> ', mtype, "_<DATASET_TYPE>_COUNT\n", paste(em_count_str, collapse="\n")))

em_prop_str <- capture.output(print(em_prop))
writeLines(paste0('> ', mtype, "_<DATASET_TYPE>_PROP\n", paste(em_prop_str, collapse="\n")))

## END RATTLE ONLY

# Exclude the "Error" column in the confusion matrix if it exists.
# Assuming the confusion matrix is a data frame with the last column
# as "Error".

main_matrix <- em_count[, -ncol(em_count)]  # Remove the "Error" column

# Calculate the overall error.

overall_error <- 1 - sum(diag(main_matrix)) / sum(main_matrix)

# Calculate class-specific errors.

class_errors <- 1 - diag(main_matrix) / rowSums(main_matrix)

# Calculate the averaged error (mean of class-specific errors).

avg_error <- mean(class_errors, na.rm = TRUE)

## BEGIN RATTLE ONLY

# Format error rates into a summary string.

error_summary <- paste(
    sprintf(
        "Overall Error = %.2f%%; Average Error = %.2f%%.",
        100 * overall_error, 100 * avg_error
    ),
    "\n",
    sep = ""
)

# Log the formatted error summary showing overall and average error rates.

writeLines(paste0('> ', mtype,  "_<DATASET_TYPE>_ERROR_MATRIX_SUMMARY: \n", paste(error_summary, collapse="\n")))

## END RATTLE ONLY
