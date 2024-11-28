# Rattle Scripts: Visual Displays
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2024-11-29 08:38:33 +1100 Graham Williams>
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

# Visual presentation of variables.
#
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials
#
# https://survivor.togaware.com/datascience/ for further details.

library(dplyr)
library(ggplot2)
library(rattle)

########################################################################
# BOX PLOT
########################################################################

# TODO 20241120 gjw ADD ALL TO LEGEND - ACTUALLY REMOVE LEGEND AS ADDS NO VALUE

# Take a copy of ds to be able to manipulate it.

tds <- ds

# When the confidence interval for the notch of the boxplot extends
# beyond the hinges (upper or lower limits of the boxplot) the notches
# go outside the hinges. To avoid this precompute the values for the
# notches and compare them to the hinges. The following does it for
# one variable. Need for all. For now 20241121 add an option to turn
# the notch on and off.

## is_notch_safe <- function(data, x, y) {
##   summary_data <- data %>%
##     group_by({{ x }}) %>%
##     summarise(
##       ymin = quantile({{ y }}, 0.25),
##       ymax = quantile({{ y }}, 0.75),
##       notch_lower = median({{ y }}) - 1.58 * IQR({{ y }}) / sqrt(n()),
##       notch_upper = median({{ y }}) + 1.58 * IQR({{ y }}) / sqrt(n())
##     )
##   any(summary_data$notch_lower < summary_data$ymin | summary_data$notch_upper > summary_data$ymax)
## }

## # Check if the notch is safe.

## notch_safe <- is_notch_safe(tds, , hwy)


# Display box plot for the selected variable.

svg("TEMPDIR/explore_visual_boxplot.svg", width=10)

tds %>%
  ggplot2::ggplot(ggplot2::aes(y=SELECTED_VAR)) +
  ggplot2::geom_boxplot(ggplot2::aes(x="All"), notch=BOXPLOT_NOTCH, fill="grey") +
  ggplot2::stat_summary(ggplot2::aes(x="All"), fun=mean, geom="point", shape=8) +
#  ggplot2::geom_boxplot(ggplot2::aes(x=GROUP_BY_VAR, fill=GROUP_BY_VAR), notch=BOXPLOT_NOTCH, show.legend=FALSE) +
#  ggplot2::stat_summary(ggplot2::aes(x=GROUP_BY_VAR), fun=mean, geom="point", shape=8) +
  ggplot2::xlab(paste("TIMESTAMP", username)) +
  ggplot2::ggtitle("Distribution of SELECTED_VAR") +
  SETTINGS_GRAPHIC_THEME()

dev.off()

########################################################################
# DENSITY
########################################################################

# TODO 20241120 gjw ADD ALL TO LEGEND

svg("TEMPDIR/explore_visual_density.svg", width=10)

ds %>%
  dplyr::select(SELECTED_VAR) %>%
  ggplot2::ggplot(ggplot2::aes(x=SELECTED_VAR)) +
  ggplot2::geom_density(lty=3) +
  ggplot2::xlab(paste("SELECTED_VAR\n\n", paste("TIMESTAMP", username), sep="")) +
  ggplot2::ggtitle("Distribution of SELECTED_VAR") +
  ggplot2::labs(y="Density") +
  SETTINGS_GRAPHIC_THEME()

dev.off()

########################################################################
# EMPIRICAL CUMULATIVE DISTRIBUTION FUNCTION
########################################################################

svg("TEMPDIR/explore_visual_ecdf.svg", width=10)

ds %>%
  dplyr::select(SELECTED_VAR) %>%
  ggplot2::ggplot() +
  # Overall ECDF
  ggplot2::stat_ecdf(aes(x = SELECTED_VAR), geom = "step", color = "black", size = 1) +
  ggplot2::xlab(paste("SELECTED_VAR\n\n", paste("TIMESTAMP", username), sep="")) +
  ggplot2::ggtitle("Empirical Cumulative Distribution of SELECTED_VAR") +
  ggplot2::labs(y=expression("ECDF - Proportion <= x")) +
  SETTINGS_GRAPHIC_THEME()

dev.off()

########################################################################
# BENFORD'S LAW 
########################################################################

# Initialies the parameters.

digit  <- 1
len    <- 1

# Build the dataset

tds <- merge(rattle::benfordDistr(digit, len),
             rattle::digitDistr(ds$SELECTED_VAR, digit, len, "SELECTED_VAR"))

# 20241120 gjw Replicate the rattle function here to ensure we are in
# harmony with the theme/colours of the other plots.
#
# TODO 20241120 gjw STILL NOT THERE YET WITH COLOURS

# Remove the NA column if it exists. A bug in the rattle
# function.

tds <- tds[,which(colnames(tds) != "NA")]

# Reorder the columns to have the colours correspdong the other plots.

tds %<>% relocate(c(All, Benford), .after=last_col())

dsm <- reshape::melt(tds, id.vars = "digit")
len <- nchar(as.character(tds[1, 1]))

# Plot the digital distribution

svg("TEMPDIR/explore_visual_benford.svg", width=10)

p <- ggplot2::ggplot(dsm,
                     ggplot2::aes_string(x      = "digit", 
                                         y      = "value",
                                         colour = "variable",
                                         shape  = "variable")) +
  ggplot2::geom_line()

if (len < 3)
  p <- p + ggplot2::geom_point()
if (substr(as.character(tds[1, 1]), 1, 1) == "1") {
  p <- p + ggplot2::scale_x_continuous(breaks = seq(10^(len - 1),
  (10^len) - 1,
  10^(len - 1)))
  } else {p <- p + ggplot2::scale_x_continuous(breaks = seq(0, 9, 1))}

p +
  ggplot2::ylab("Frequency (%)") +
  ggplot2::xlab("Digits") +
  ggplot2::theme(legend.title = ggplot2::element_blank()) +
  ggtitle("Digital Analysis of First Digit of SELECTED_VAR") +
  ggplot2::xlab(paste("Digits\n\n", paste("TIMESTAMP", username), sep="")) +
  SETTINGS_GRAPHIC_THEME()

dev.off()

########################################################################
# PAIRS - REQUIRES TWO VARIABLES
########################################################################

# Display a pairs plot for the selected variables. 

# Use GGally's ggpairs() to do the hard work.

## svg("TEMPDIR/explore_visual_pairs.svg", width=10)

## ds %>%
##   dplyr::mutate(GROUP_BY_VAR=as.factor(GROUP_BY_VAR)) %>%
##   GGally::ggpairs(columns=c(3,4),
##         mapping=ggplot2::aes(colour=GROUP_BY_VAR, alpha=0.5, shape=GROUP_BY_VAR),
##                 diag=list(continuous="densityDiag",
##                           discrete="barDiag"),
##                 upper=list(continuous="cor",
##                            combo="box",
##                            discrete="ratio"),
##                 lower=list(continuous="points",
##                            combo="denstrip",
##                            discrete="facetbar"),
##                 legend=3) +
##   ggplot2::theme(panel.grid.major=ggplot2::element_blank(), legend.position="right") +
##   ggplot2::xlab(paste("\n\n", "TIMESTAMP", sep=""))

  
# ggplot2::scale_alpha_continuous(guide=FALSE) +
#  ggplot2::scale_fill_brewer(palette=rattlePalette) +
#  ggplot2::scale_colour_brewer(palette=rattlePalette)

# dev.off()
