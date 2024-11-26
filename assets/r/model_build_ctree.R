# Rattle Scripts: From dataset ds build a conditional inference tree.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2024-10-07 17:03:05 +1100 Graham Williams>
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
# Author: Graham Williams

# Load required packages for conditional inference trees

library(party)       # Conditional inference trees
library(partykit)    # Enhanced visualization and interpretation
library(rattle)  

# Define model type and description
mtype <- "ctree"
mdesc <- "Conditional Inference Tree"

# Determine what type of model to build based on the number of values of the target variable
# Not needed for ctree as it automatically handles the data type

# Define the formula for the model

# TODO 20240930 gjw SHOULDN'T THIS BE FRO `model_template.r`

form <- as.formula(paste(target, "~ ."))

control <- ctree_control(
  MINSPLIT, MINBUCKET, MAXDEPTH
)

# Train a Conditional Inference Tree model using ctree
model_ctree <- ctree(
  formula   = form,
  data      = trds,
  na.action = na.exclude,
  control   = control
)

# Generate a textual view of the Conditional Inference Tree model
print(model_ctree)
summary(model_ctree)
cat("\n")

# Plot the resulting Conditional Inference Tree.

svg("TEMPDIR/model_tree_ctree.svg")
plot(model_ctree, main = paste("Conditional Inference Tree", target))
dev.off()

# Prepare probabilities for predictions.

predicted_probs <- predict(model_ctree, 
                           newdata      = tuds, 
                           type         = "prob")
predicted <- apply(predicted_probs, 1, function(x) colnames(predicted_probs)[which.max(x)])
  
actual <- as.character(actual_tu)
actual <- actual[!is.na(actual)]
  
# Create numeric risks vector.

risks <- as.character(risk_tu)
risks <- risks[!is.na(risks)]
risks <- as.numeric(risks)

# Get unique levels of predicted.

levels_predicted <- unique(predicted)
levels_actual <- unique(actual)
predicted <- as.character(predicted)
predicted_numeric <- ifelse(predicted == levels_predicted[1], 0, 1)
actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)

# Generate risk chart.

svg("TEMPDIR/model_ctree_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks) +
  labs(title       = "Risk Chart - Tuning Dataset") +
  theme(plot.title = element_text(size=14))
dev.off()
