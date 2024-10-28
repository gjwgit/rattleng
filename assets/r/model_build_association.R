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

# Association using arules()
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

library(arules) 

# Model type and description.

mtype <- "arules"
mdesc <- "Association Rules"

tds <- ds[tr, vars]

# Generate transactions from the dataset.

transactions <- as(tds, "transactions")

# Build the association model using the Apriori algorithm.

model_arules <- apriori(
  data = transactions,
  parameter = list(support = 0.1, confidence = 0.1, minlen = 2)
)

# Generate textual output of the 'Association Rules' model.

print(summary(model_arules))

# Plot the relative importance of the rules using arulesViz.

library(arulesViz)

svg("TEMPDIR/model_arules_item_frequency.svg")

itemFrequencyPlot(transactions, topN = 10, type = "relative")
dev.off()
