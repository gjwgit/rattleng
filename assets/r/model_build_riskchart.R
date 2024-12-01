# Using the `model` and the `trds` and `tuds` generate risk charts.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-11-30 21:41:15 +1100 Graham Williams>
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

# Prepare probabilities for predictions as the number of columns as
# there are target values.

pr_tr <- predict(model, newdata = trds)[,2]

# Use rattle's evaluateRisk.

eval <- rattle::evaluateRisk(pr_tr, actual_tr, risk_tr)

# Generate the risk chart.

svg(glue("TEMPDIR/model_{mtype}_risk_tr.svg"), width=11)
title <- glue("Risk Chart &#8212; {mdesc} &#8212; {basename('FILENAME')} *training* TARGET_VAR")
rattle::riskchart(pr_tr, actual_tr, risk_tr,
                  title          = title,
                  risk.name      = "RISK_VAR",
                  recall.name    = "TARGET_VAR",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE) +
  SETTINGS_GRAPHIC_THEME() +
  theme(plot.title = element_markdown())
dev.off()

########################################################################

# Prepare probabilities for predictions as the number of columns as
# there are target values.

pr_tu <- predict(model, newdata = tuds)[,2]

# Use rattle's evaluateRisk.

eval <- rattle::evaluateRisk(pr_tu, actual_tu, risk_tu)

# Generate the risk chart.

svg(glue("TEMPDIR/model_{mtype}_risk_tu.svg"), width=11)
title <- glue("Risk Chart &#8212; {mdesc} &#8212; {basename('FILENAME')} *tuning* TARGET_VAR")
rattle::riskchart(pr_tu, actual_tu, risk_tu,
                  title          = title,
                  risk.name      = "RISK_VAR",
                  recall.name    = "TARGET_VAR",
                  show.lift      = TRUE,
                  show.precision = TRUE,
                  legend.horiz   = FALSE) +
  SETTINGS_GRAPHIC_THEME() +
  theme(plot.title = element_markdown())
dev.off()
