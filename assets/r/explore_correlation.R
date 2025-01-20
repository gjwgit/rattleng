# Rattle Scripts: Correlation Analysis
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-08-29 17:16:32 +0800 Graham Williams>
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

# Load required packages from the local library into the R session.

# Generate a correlation plot for the variables. 

# Correlations work for numeric variables only.

cor <- cor(ds[setdiff(numc,ignore)], use="pairwise", method="pearson")

# Order the correlations by their strength.

ord <- order(cor[1,])
cor <- cor[ord, ord]

# Display a textual table of the actual correlations.

print(round(cor,2))


# Generate the chart.

svg("<TEMPDIR>/explore_correlation.svg")
corrplot::corrplot(cor,
                   method = 'ellipse',
                   order  = 'AOE',
                   type   = 'full',
                   tl.srt = 45,
                   mar    = c(0,0,1,0))
title(main = "Correlation weather.csv using Pearson",
      sub  = paste("<TIMESTAMP>", username))
dev.off()

## <GGCORRPLOT>

svg("<TEMPDIR>/explore_correlation_ggcorrplot.svg")
ggcorrplot::ggcorrplot(cor, method='circle')
dev.off()
