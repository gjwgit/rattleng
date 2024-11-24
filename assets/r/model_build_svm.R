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
library(rattle)

# Define the dataset, input, and target.

tds <- ds[tr, vars]
svm_kernel <- SVM_KERNEL

if (svm_kernel == "polydot") {
  svm_model <- ksvm(
    as.factor(tds[[target]]) ~ .,
    data       = tds,
    kernel     = SVM_KERNEL,
    kpar       = list("degree" = SVM_DEGREE),
    prob.model = TRUE
  )
} else {
  svm_model <- ksvm(
    as.factor(tds[[target]]) ~ .,
    data       = tds,
    kernel     = SVM_KERNEL,
    prob.model = TRUE
  )
}

# Print a summary of the trained SVM model.

print(svm_model)
dev.off()

# Prepare probabilities for predictions.

predicted <- kernlab::predict(svm_model, 
                              newdata    = tuds,
                              type       = "probabilities")[,2]
  
actual <- as.character(tuds[[target]])
  
# Create numeric risks vector.

risks <- as.character(ds[[risk]])

risks <- risks[!is.na(risks)]

risks <- as.numeric(risks)

# Get unique levels of predicted.

levels_predicted <- unique(predicted)
levels_actual <- unique(actual)
predicted <- as.character(predicted)
predicted_numeric <- ifelse(predicted == levels_predicted[1], 0, 1)
actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(predicted))

# Replace NA or NaN in predicted_numeric.

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# Align vectors (ensure all are of the same length).
# Use the minimum length of the vectors.

min_length <- min(length(predicted_numeric), length(actual_numeric), length(risks))
predicted_numeric <- predicted_numeric[1:min_length]
actual_numeric <- actual_numeric[1:min_length]
risks <- risks[1:min_length]

# Handle missing or invalid values.
# Replace NA or NaN in predicted_numeric with a default value (e.g., 0).

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

# Replace NA or NaN in actual_numeric with a default value (e.g., 0).

actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

# Replace NA or NaN in risks with a default value (e.g., 1).

risks <- ifelse(is.na(risks) | is.nan(risks), 1, risks)

# Generate risk chart.

svg("TEMPDIR/model_svm_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks) +
  labs(title       = "Risk Chart - Tuning Dataset") +
  theme(plot.title = element_text(size=14))
dev.off()
