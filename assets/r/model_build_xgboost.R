# Build an XGBoost model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2025-08-05 17:13:07 +1000 Graham Williams>
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
# FOR MORE <DETAILS>.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Zheyuan Xu

# Load required libraries.

library(Ckmeans.1d.dp)  # Needed for xgb.ggplot.importance
library(data.table)     # Display data as a nicely formatted table.
library(xgboost)        # For XGBoost model.

# Define model type and description.

mtype <- "xgboost"
mdesc <- "XGBoost"

# 20260818 gjw Build the model against the xgboost 3 interface rather than
# through `rattle::xgboost()`, which no longer works. That wrapper is written
# for the xgboost 2 interface and fails three ways under xgboost 3: it passes
# the target as a numeric 0/1 label, and a numeric `y` is refused for
# `binary:logistic` ("Got numeric 'y'"); it passes `data`, `label` and `eta`,
# all since renamed to `x`, `y` and `learning_rate`; and it passes `metrics`,
# which is no longer recognised. It then assigns the formula onto the model
# object, which under xgboost 3 is an ALTREP list that refuses element
# assignment ("ALTLIST classes must provide a Set_elt method").
#
# So we do the work here. The formula is kept in `xgb_form` alongside the
# model, rather than attached to it, and `xgb_predict()` below stands in for
# the `predict.xgb.formula()` we can no longer reach.

xgb_form <- form

# The model needs a numeric matrix, so the factors are spread into indicator
# columns. Rows with missing values cannot go into the matrix and are dropped.

xgb_train <- na.omit(trds)
xgb_x     <- Matrix::sparse.model.matrix(xgb_form, data=xgb_train)

# A factor target is a classification and a numeric one a regression, and
# xgboost 3 decides what it is from the type of `y`, so the objective chosen
# in SETTINGS has to agree with it.

xgb_y <- xgb_train[[target]]
if (! is.numeric(xgb_y)) xgb_y <- as.factor(xgb_y)

# The classes the model predicts, remembered here because the model predicts a
# probability and something has to turn that back into a class. Taking them from
# the training data rather than from the data being predicted means a prediction
# is labelled the same way wherever it comes from, including where the data has
# no target column to take them from.

xgb_levels <- levels(xgb_y)

model_xgb <- xgboost::xgboost(x                 = xgb_x,
                              y                 = xgb_y,
                              max_depth         = <BOOST_MAX_DEPTH>,     # Maximum depth of a tree
                              learning_rate     = <BOOST_LEARNING_RATE>, # Learning rate
                              nthread           = <BOOST_THREADS>,       # Set the number of threads
                              num_parallel_tree = 1,
                              nrounds           = <BOOST_ITERATIONS>,
                              objective         = <BOOST_OBJECTIVE>,
                              verbosity         = 0)

# The variables the model was built on, with the target dropped. Fixing these
# here means a prediction asks for exactly the columns the model was trained on,
# in the same order, whatever the data it is handed. The target is dropped
# because it is not needed to predict and is often not there to be had: an
# interactive prediction supplies only the inputs, and so does a dataset loaded
# on EVALUATE to score rather than to evaluate.

xgb_terms <- delete.response(terms(xgb_form, data=xgb_train))

# Predict from a data frame, as the rest of Rattle expects to be able to.
#
# The model itself only takes a matrix, and building that matrix drops any
# observation with a missing value, which would leave the predictions shorter
# than the observations they are to be compared against. So the dropped rows
# are put back as missing predictions, keeping one prediction per observation.

xgb_predict <- function(model, data) {
  mf <- model.frame(xgb_terms, data=data, na.action=na.omit)
  x  <- Matrix::sparse.model.matrix(xgb_terms, data=mf)

  pr <- predict(model, x)

  for (i in as.vector(attr(mf, "na.action")))
    pr <- if (i > length(pr)) c(pr, NA) else c(pr[1:i-1], NA, pr[i:length(pr)])

  return(pr)
}

# Save the model to the <TEMPLATE> variable `model` and the predicted
# values appropriately.

model <- model_xgb

# Print the summary of the trained model.

print(model_xgb)
summary(model_xgb)


# Feature Importance Plot.

svg("<TEMPDIR>/model_xgb_importance.svg")
importance_matrix <- xgb.importance(model = model_xgb)

# Create a ggplot-based importance plot. Uses Ckmeans.1d.dp.

importance_plot <- xgb.ggplot.importance(importance_matrix, measure = "Gain", rel_to_first = FALSE)

# Convert the importance_matrix to a data.table.

importance_dt <- as.data.table(importance_matrix)

# Format the output to match your desired style.

print(importance_dt, row.names = FALSE)

# Add value labels to the bars using geom_text().

importance_plot <- importance_plot +
  geom_text(aes(label = round(Importance, 4), y = Importance),
            hjust = -0.2,
            size = 3,)

# Increase plot limits to make space for the labels.

# 20260818 gjw The measure asked for above is the Gain. It used to be read from
# an `Importance` column, which the table does not have: the plot works out an
# `Importance` from whichever measure was asked for, and under xgboost 2 it added
# that column back onto the table it was given, by reference. Under xgboost 3 it
# does not, and `max()` of the column that is no longer there returns -Inf, so no
# space was made for the labels.

importance_plot <- importance_plot + expand_limits(y = max(importance_matrix$Gain) * 1.2)

# Display the plot.

print(importance_plot)

dev.off()
