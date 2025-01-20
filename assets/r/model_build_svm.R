# From dataset `trds` build a `ksvm()` support vector machine.
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 16:20:53 +1100 Graham Williams>
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

# TIMESTAMP
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(kernlab)

# Define the model type and description for file paths and titles.

mtype <- "svm"
mdesc <- "Support Vector Machine"

# Define the dataset, input, and target.

svm_kernel <- <SVM_KERNEL>

if (svm_kernel == "polydot") {
  model_svm <- ksvm(
    form,
    data       = trds,
    kernel     = <SVM_KERNEL>,
    kpar       = list("degree" = <SVM_DEGREE>),
    prob.model = TRUE
  )
} else {
  model_svm <- ksvm(
    form,
    data       = trds,
    kernel     = <SVM_KERNEL>,
    prob.model = TRUE
  )
}

# Output a summary of the trained SVM model.

print(model_svm)
