# From `predicted`, `actual`, and `risk` generate a riskchart.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 16:21:31 +1100 Graham Williams>
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

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(glue)         # Format strings: glue().
library(rattle)       # Generate a risk chart.

####################################

# Convert factors to characters, then to numeric.

predicted_numeric <- as.numeric(factor(predicted)) - 1
actual_numeric <- as.numeric(factor(actual)) - 1

# Combine logical NA checks for both vectors.

valid_indices <- !is.na(predicted_numeric) & !is.na(actual_numeric)

# Filter the vectors based on valid indices.

filtered_predicted_numeric <- predicted_numeric[valid_indices]
filtered_actual_numeric <- actual_numeric[valid_indices]
filtered_risk <- risk[valid_indices]

# Use rattle's evaluateRisk to generate data required for a Risk Chart.

eval <- rattle::evaluateRisk(filtered_predicted_numeric, filtered_actual_numeric, filtered_risk)

# Build title string.

title <- glue("Risk Chart &#8212; {mdesc} &#8212; ",
              "{mtype} {basename('<FILENAME>')} ",
              "*{dtype}* <TARGET_VAR>")
title

# Generate the risk chart.

svg(glue("<TEMPDIR>/model_{mtype}_riskchart_{dtype}.svg"), width=11)
rattle::riskchart(filtered_predicted_numeric, filtered_actual_numeric, filtered_risk,
                  title          = title,
                  risk.name      = "<RISK_VAR>",
                  recall.name    = "<TARGET_VAR>",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(plot.title = element_markdown())
dev.off()
