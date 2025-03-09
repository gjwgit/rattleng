# Rattle Scripts: Correlation Analysis
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2025-03-09 19:30:08 +1100 Graham Williams>
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

# Correlation Analysis
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials
#
# https://survivor.togaware.com/datascience/ for further details.

# Generate a correlation plot for the variables. Correlations work for
# numeric variables only.

cor <- cor(ds[setdiff(numc, ignore)], use="pairwise", method="pearson")

# The correlations are ordered by their strength.

ord <- order(cor[1,])
cor <- cor[ord, ord]

# Display a textual table of the actual correlations.
##
## 20250222 gjw On Windows the layout is misaligned. we might try some
## alternatives as in #903. It's not a Rattle issue per se. If you
## copy the table and paste into Notepad we get the same misalignment.

##
##print(round(cor,2))
##
print(format(round(cor, 2), nsmall=2, width=6), quote=FALSE)
##
## print(format(round(cor, 2), nsmall = 2, width = 6), quote = FALSE)
##
## knitr::kable(round(cor, 2))

# Generate the chart.

svg("<TEMPDIR>/explore_correlation.svg")
corrplot::corrplot(cor,
                   method = 'ellipse',
                   order  = 'AOE',
                   type   = 'full',
                   tl.srt = 45,
                   mar    = c(0,0,1,0))
title(main = glue("Correlation {basename('<FILENAME>')} using Pearson"),
      sub  = paste("<TIMESTAMP>", username))
dev.off()

## <GGCORRPLOT>

svg("<TEMPDIR>/explore_correlation_ggcorrplot.svg")
ggcorrplot::ggcorrplot(cor, method='circle')
dev.off()
