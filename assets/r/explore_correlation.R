# Undertake a Correlation Analysis over all except the IGNORED variables.
#
# Copyright (C) 2024-2026, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2026-01-06 14:06:35 +1100 Graham Williams>
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
# @williams:2017:essentials
#
# https://onepager.togaware.com/correlated-numeric-variables.html for further details.

# Generate a correlation plot for the numeric variables. In general
# correlations are best defined for numeric variables only.

# 20260106 gjw The first step is to generate a correlation matrix,
# `corm`, from the numeric variables, excluding those that are
# ignored, and ensuring we include the target if it is numeric. We
# check if it is numeric and if so save the target name into `numt`
# and if there is no target or it is categoric we set `numt` to
# NULL). We then build `corv` as the list of numeric variables over
# which we will perform the correlation analysis.

numt <- if(! is.null(target) & is.numeric(ds[[target]])) target else NULL

corv <- setdiff(union(numc, numt), ignore)

corm <- cor(ds[corv],
            use    = "pairwise",
            method = "pearson")

# 20260106 gjw We can order the correlations by their strength. This
# is useful for the textual display, but probably has no impact on the
# visualisations.

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
print(format(round(corm[nrow(corm):1,nrow(corm):1], 2), nsmall=2, width=6), quote=FALSE)
##
## print(format(round(corm, 2), nsmall = 2, width = 6), quote = FALSE)
##
## knitr::kable(round(corm, 2))

# Generate a non-ggplot correlation plot.

tl <- glue("Pearson Correlation of Variables {basename('<FILENAME>')}")

svg("<TEMPDIR>/explore_correlation.svg")
corrplot::corrplot(corm[nrow(corm):1,nrow(corm):1],
                   method = 'ellipse',
                   type   = 'full',
                   tl.srt = 45,
                   mar    = c(0,0,1,0))
title(main = tl,
      sub  = paste("<TIMESTAMP>", username))
dev.off()

# GGCORRPLOT

p <- ggcorrplot::ggcorrplot(corm[nrow(corm):1,],
                            method = 'circle',
                            color  = c("red", "white", "blue"),
                            title  = "Alt " + tl ) +
  labs(x="",  y="", subtitle=paste("<TIMESTAMP> ", username)) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(axis.text.x=element_text(angle=45, hjust=0)) +
     scale_x_discrete(position = "top")

svg("<TEMPDIR>/explore_correlation_ggcorrplot.svg")
p
dev.off()

png("<TEMPDIR>/explore_correlation_ggcorrplot.png")
p
dev.off()

# GGDENRO Dendrogram

# Calculate correlation using the absolute value of the correlation
# so strongly negateive and strongly positive correlations have the
# same strength.

cord <- as.dist(1 - abs(corm))

# From the correlation strengths use a hierarchical clustering
# algorithm to group together the variables, incrementally.

hc <- hclust(cord)

# We can now generate the dendrogram plot.

svg("<TEMPDIR>/explore_correlation_ggdendro.svg")
ggdendro::ggdendrogram(hc, rotate=TRUE, size=2) +
  labs(title = glue("Variable Correlation {basename('<FILENAME>')}"),
       x        = "Variable",
       y        = "Relative Correlation",
       subtitle = paste("<TIMESTAMP> ", username)) +
  <SETTINGS_GRAPHIC_THEME>()
dev.off()
