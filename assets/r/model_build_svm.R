# Rattle Scripts: From dataset ds build an association model.
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

target_var <- target
train_data <- ds[tr, vars]
input_vars <- setdiff(names(train_data), target_var)

svm_model <- ksvm(
  as.factor(train_data[[target_var]]) ~ .,
  data = train_data[, c(input_vars, target_var)],
  kernel = "rbfdot",
  prob.model = TRUE
)

# Print a summary of the trained SVM model.

print(svm_model)

png("TEMPDIR/svm_model_plot.png")
plot(svm_model, data = train_data)
dev.off()
