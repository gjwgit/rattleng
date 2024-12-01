# From `predicted`, `actual`, and `risk` generate a riskchart.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-12-01 20:28:22 +1100 Graham Williams>
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

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(ggtext)       # Support markdown in ggplot titles.
library(glue)         # Format strings: glue().
library(rattle)

########################################################################

# Use rattle's evaluateRisk.

eval <- rattle::evaluateRisk(predicted, actual, risk)

# Generate the risk chart.

fname <- glue("TEMPDIR/model_{mtype}_risk_{dtype}.svg")
fname
svg(fname, width=11)
title <- glue("Risk Chart &#8212; {mdesc} &#8212; {basename('FILENAME')} *{dtype}* TARGET_VAR")
rattle::riskchart(predicted, actual, risk,
                  title          = title,
                  risk.name      = "RISK_VAR",
                  recall.name    = "TARGET_VAR",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE) +
  SETTINGS_GRAPHIC_THEME() +
  theme(plot.title = element_markdown())
dev.off()
