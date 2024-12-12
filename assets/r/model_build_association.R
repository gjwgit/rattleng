# From dataset `ds` build an `apriori()` association model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-12-12 17:09:47 +1100 Graham Williams>
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
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(arules)

# Define the model type and description for file paths and titles.

mtype <- "arules"
mdesc <- "Association Rules"

# Depending on whether we consider the dataset `ds` as a collection of
# baskets or not, we build our transactions dataset. For `ds` as a
# basket it will have two columns, one (IDENT) identifying the basket
# and the other (TARGET) identifying an item contained in the basket.

if(ASSOCIATION_BASKETS) {
  # We need to get the IDENT variable from ds since all IDENTs are
  # removed from trds.

  transactions <- as(split(trds$TARGET_VAR, ds[tr, "IDENT_VAR"]), "transactions")

} else {

  transactions <- as(trds, "transactions")

}

# Build the association model using the Apriori algorithm.

model_arules <- apriori(
  data      = transactions,
  parameter = list(support    = ASSOCIATION_SUPPORT,
                   confidence = ASSOCIATION_CONFIDENCE,
                   minlen     = ASSOCIATION_MIN_LENGTH)
)

# Generate textual output of the 'Association Rules' model.

print(summary(model_arules))

# Limit the number of rules for display and calculating the interest
# measures. Generally this can be very large and if so the `inspect()`
# will be very time consuming and it appears the app has frozen.

top_rules <- sort(model_arules, by = ASSOCIATION_RULES_SORT_BY)
top_rules <- top_rules[1:min(length(top_rules), ASSOCIATION_INTEREST_MEASURE)]

# Show the rules identified.

inspect(top_rules)

# Interestingness Measures.

measures <- interestMeasure(
  top_rules,
  c("chiSquare", "hyperLift", "hyperConfidence", "leverage", "oddsRatio", "phi"),
  transactions,
)

# Print the computed interest measures.

print(measures)

# Plot the relative importance of the rules using arulesViz.

library(arulesViz)

svg("TEMPDIR/model_arules_item_frequency.svg")
itemFrequencyPlot(transactions, topN = 10, type = "relative")
dev.off()

png("TEMPDIR/model_arules_item_plot.png")
plot(model_arules, method="graph")
dev.off()
