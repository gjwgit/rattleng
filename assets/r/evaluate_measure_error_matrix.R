# Using `actual` and `predicted` generate error matrix.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-17 19:45:10 +1100 Graham Williams>
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

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(rattle)       # Generate an error matrix.

em_count <- rattle::errorMatrix(actual, predicted, count=TRUE)
##
## 20241229 zy Capture the output of the error matrix and print it to
## the console.  The print line includes '> ` for the dart script to
## identify the error matrix. 20250106 gjw Use `rat()` rather than
## `cat()` to avoid exposing the command to the user's exported
## script.
##
rat(paste('> ', mtype, "_<DATASET_TYPE>_COUNT ", sep=""))
em_count

# Generate a confusion matrix with proportions (relative frequencies)
# rather than counts.

em_prop <- rattle::errorMatrix(actual, predicted)
##
## 20241229 zy Capture the output of the error matrix and print it to
## the console.  The print line includes '> ` for the dart script to
## identify the error matrix. 20250106 gjw Use `rat()` rather than
## `cat()` to avoid exposing the command to the user's exported
## script.
##
rat(paste('> ', mtype, "_<DATASET_TYPE>_PROP ", sep = ""))
em_prop

# Exclude the "Error" column in the confusion matrix if it exists
# Assuming the confusion matrix is a data frame with the last column as "Error".

main_matrix <- em_count[, -ncol(em_count)]  # Remove the "Error" column

# Calculate the overall error.

overall_error <- 1 - sum(diag(main_matrix)) / sum(main_matrix)

# Calculate class-specific errors.

class_errors <- 1 - diag(main_matrix) / rowSums(main_matrix)

# Calculate the averaged error (mean of class-specific errors).

avg_error <- mean(class_errors, na.rm = TRUE)

# Format error rates into a summary string.

error_summary <- paste(
    sprintf(
        "Overall Error = %.2f%%; Average Error = %.2f%%.",
        100 * overall_error, 100 * avg_error
    ),
    "\n",
    sep = ""
)

# Log the error matrix type identifier.

rat(paste('> ', mtype, "_<DATASET_TYPE>_ERROR_MATRIX_SUMMARY: ", sep = ""))

# Log the formatted error summary showing overall and average error rates.

cat(error_summary)
