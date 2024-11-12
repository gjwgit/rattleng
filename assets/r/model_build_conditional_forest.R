# Rattle Scripts: From dataset ds build a random forest model.
#
# Copyright (C) 2023, Togaware Pty Ltd.
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
# Author: Graham Williams

# Random Forest using cforest()
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages

library(ggplot2)
library(rattle)
library(party)
library(reshape2)

mtype <- "conditionalForest"
mdesc <- "Forest"

model_conditionalForest <- cforest(
  form,
  data=tds,
  controls=cforest_unbiased(
    ntree=RF_NUM_TREES,
    mtry=RF_MTRY,
  )
)

# Generate textual output of the 'Conditional Random Forest' model.

print(model_conditionalForest)

# List the importance of the variables.

importance_values <- party::varimp(model_conditionalForest)
importance_df <- data.frame(
  Variable = names(importance_values),
  Importance = importance_values
)
importance_df <- importance_df[order(importance_df$Importance, decreasing = TRUE), ]

print(importance_df)

# Display tree number.

prettytree(model_conditionalForest@ensemble[[RF_NO_TREE]], names(model_conditionalForest@data@get("input")))

svg("TEMPDIR/model_conditional_forest.svg")

ggplot(importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Variable Importance from Conditional Forest",
    x = "Variable",
    y = "Importance"
  ) +
  theme_minimal()

dev.off()
