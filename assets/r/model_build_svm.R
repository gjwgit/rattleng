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

# Define the model type and description for file paths and titles.

mtype <- "svm"
mdesc <- "Support Vector Machine"

# Define the dataset, input, and target.

svm_kernel <- SVM_KERNEL

if (svm_kernel == "polydot") {
  svm_model <- ksvm(
    as.factor(trds[[target]]) ~ .,
    data       = trds,
    kernel     = SVM_KERNEL,
    kpar       = list("degree" = SVM_DEGREE),
    prob.model = TRUE
  )
} else {
  svm_model <- ksvm(
    as.factor(trds[[target]]) ~ .,
    data       = trds,
    kernel     = SVM_KERNEL,
    prob.model = TRUE
  )
}

# Save the model to the TEMPLATE variable `model` and the predicted
# values appropriately.

model <- svm_model

predicted_tr <- predict(model, newdata = trds, type = "probabilities")[,2]
predicted_tu <- predict(model, newdata = tuds, type = "probabilities")[,2]
predicted_te <- predict(model, newdata = teds, type = "probabilities")[,2]

# Print a summary of the trained SVM model.

print(svm_model)

# Prepare probabilities for predictions.

pr_tu <- predict(svm_model, newdata = tuds, type = "probabilities")[,2]

# Get unique levels of pr_tu.

levels_predicted <- unique(pr_tu)
levels_actual <- unique(actual)
predicted_numeric <- ifelse(pr_tu == levels_predicted[1], 0, 1)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(pr_tu))

# Replace NA or NaN in predicted_numeric.

predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

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

# Generate risk chart.

svg("TEMPDIR/model_svm_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks,
                  title          = "Risk Chart SVM FILENAME [tuning] TARGET_VAR ", 
                  risk.name      = "RISK_VAR",
                  recall.name    = "TARGET_VAR",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE) +
    SETTINGS_GRAPHIC_THEME()
dev.off()
