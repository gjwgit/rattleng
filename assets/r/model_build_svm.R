# Rattle Scripts: From dataset ds build a SVM model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-09-07 15:38:57 +1000 Graham Williams>
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

library(kernlab)

# Define the dataset, input, and target.

tds <- ds[tr, vars]
input_vars <- setdiff(names(tds), target)
svm_kernel <- SVM_KERNEL

if (svm_kernel == "polydot") {
  svm_model <- ksvm(
    as.factor(tds[[target]]) ~ .,
    data       = tds[, c(input_vars, target)],
    kernel     = SVM_KERNEL,
    kpar       = list("degree" = SVM_DEGREE),
    prob.model = TRUE
  )
} else {
  svm_model <- ksvm(
    as.factor(tds[[target]]) ~ .,
    data       = tds[, c(input_vars, target)],
    kernel     = SVM_KERNEL,
    prob.model = TRUE
  )
}

# Print a summary of the trained SVM model.

print(svm_model)
dev.off()
