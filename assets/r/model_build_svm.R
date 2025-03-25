# From dataset `trds` build a `ksvm()` support vector machine.
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-03-26 05:49:38 +1100 Graham Williams>
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
library(mice)

# Define the model type and description for file paths and titles.

mtype <- "svm"
mdesc <- "Support Vector Machine"

# Define the dataset, input, and target.

svm_kernel <- <SVM_KERNEL>
##
## If we set the seed here then the model built is identical to Rattle
## V5. In V6 though the seed is set quite a bit earlier just before
## the partition. How important is it to get identical to V5?  Note
## that it should not be concerning though and students need to
## understand that big or subtle variations can affect results in
## Machine Learning, as it is not specifically deterministic, compared
## to what we are used to in computing. In the ATO it was always
## disconcerting to the Executive when we got small random
## variations. It was an opportunity to educate them! (gjw 20250325)
##
## set.seed(42)

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
