# Rattle Scripts: Correlation Analysis
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-07-31 13:19:30 +1000 Graham Williams>
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
# numeric variables only. The first step is to generate the
# correlation matrix.

corm <- cor(ds[setdiff(numc, ignore)], use="pairwise", method="pearson")

# The correlations are ordered by their strength.

ord <- order(corm[1,])
corm <- corm[ord, ord]

# Display a textual table of the actual correlations.
##
## 20250222 gjw On Windows the layout is misaligned. we might try some
## alternatives as in #903. It's not a Rattle issue per se. If you
## copy the table and paste into Notepad we get the same misalignment.

##
##print(round(corm,2))
##
print(format(round(corm, 2), nsmall=2, width=6), quote=FALSE)
##
## print(format(round(corm, 2), nsmall = 2, width = 6), quote = FALSE)
##
## knitr::kable(round(corm, 2))

# Generate the chart.

svg("<TEMPDIR>/explore_correlation.svg")
corrplot::corrplot(corm,
                   method = 'ellipse',
                   order  = 'AOE',
                   type   = 'full',
                   tl.srt = 45,
                   mar    = c(0,0,1,0))
title(main = glue("Correlation {basename('<FILENAME>')} using Pearson"),
      sub  = paste("<TIMESTAMP>", username))
dev.off()

## GGCORRPLOT

svg("<TEMPDIR>/explore_correlation_ggcorrplot.svg")
ggcorrplot::ggcorrplot(corm, method='circle')
dev.off()

png("<TEMPDIR>/explore_correlation_ggcorrplot.png")
ggcorrplot::ggcorrplot(corm, method='circle')
dev.off()

# GGDENRO Dendrogram

#library(ggdendro)
#library(ggplot2)

# Calculate correlation and clustering.

cor_matrix <- cor(mtcars)
cord <- as.dist(1 - abs(corm))  # Use absolute correlation
hc <- hclust(cord, method="ward.D2")

# Create dendrogram plot.

svg("<TEMPDIR>/explore_correlation_ggdendro.svg")
ggdendro::ggdendrogram(hc, rotate = TRUE, size = 2) +
  labs(title = "Variable Correlation Dendrogram") +
  theme_minimal()
dev.off()
