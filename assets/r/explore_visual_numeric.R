# Rattle Scripts: Visual Displays
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2024-11-20 16:30:11 +1100 Graham Williams>
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

# TODO 20241120 gjw ADD ALL TO LEGEND

# Display box plot for the selected variable.

svg("TEMPDIR/explore_visual_boxplot.svg", width=10)

ds %>%
  dplyr::mutate(GROUP_BY_VAR=as.factor(GROUP_BY_VAR)) %>%
  ggplot2::ggplot(ggplot2::aes(y=SELECTED_VAR)) +
  ggplot2::geom_boxplot(ggplot2::aes(x="All"), notch=TRUE, fill="grey") +
  ggplot2::stat_summary(ggplot2::aes(x="All"), fun=mean, geom="point", shape=8) +
  ggplot2::geom_boxplot(ggplot2::aes(x=GROUP_BY_VAR, fill=GROUP_BY_VAR), notch=TRUE) +
  ggplot2::stat_summary(ggplot2::aes(x=GROUP_BY_VAR), fun=mean, geom="point", shape=8) +
  ggplot2::xlab(paste("GROUP_BY_VAR\n\n", paste("TIMESTAMP", username), sep="")) +
  ggplot2::ggtitle("Distribution of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::theme(legend.position="none") +
  theme_default()

dev.off()

########################################################################
# DENSITY
########################################################################

# TODO 20241120 gjw ADD ALL TO LEGEND

svg("TEMPDIR/explore_visual_density.svg", width=10)

ds %>%
  dplyr::mutate(GROUP_BY_VAR=as.factor(GROUP_BY_VAR)) %>%
  dplyr::select(SELECTED_VAR, GROUP_BY_VAR) %>%
  ggplot2::ggplot(ggplot2::aes(x=SELECTED_VAR)) +
  ggplot2::geom_density(lty=3) +
  ggplot2::geom_density(ggplot2::aes(fill=GROUP_BY_VAR, colour=GROUP_BY_VAR), alpha=0.55) +
  ggplot2::xlab(paste("SELECTED_VAR\n\n", paste("TIMESTAMP", username), sep="")) +
  ggplot2::ggtitle("Distribution of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::labs(fill="GROUP_BY_VAR", y="Density") +
  theme_default()

dev.off()

########################################################################
# EMPIRICAL CUMULATIVE DISTRIBUTION FUNCTION
########################################################################

svg("TEMPDIR/explore_visual_ecdf.svg", width=10)

ds %>%
  dplyr::mutate(GROUP_BY_VAR=as.factor(GROUP_BY_VAR)) %>%
  dplyr::select(SELECTED_VAR, GROUP_BY_VAR) %>%
  ggplot2::ggplot() +
  # Overall ECDF
  ggplot2::stat_ecdf(aes(x = SELECTED_VAR), geom = "step", color = "black", size = 1) +
  # Group ECDFs
  ggplot2::stat_ecdf(aes(x = SELECTED_VAR, color = GROUP_BY_VAR), geom = "step") +
  ggplot2::xlab(paste("SELECTED_VAR\n\n", paste("TIMESTAMP", username), sep="")) +
  ggplot2::ggtitle("Empirical Cumulative Distribution of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::labs(fill="GROUP_BY_VAR", y=expression("ECDF - Proportion <= x")) +
  theme_default()

dev.off()

########################################################################
# BENFORD'S LAW 
########################################################################

# Initialies the parameters.

digit  <- 1
len    <- 1

# Build the dataset

tds <- merge(rattle::benfordDistr(digit, len),
             rattle::digitDistr(ds$min_temp, digit, len, "All"))

for (i in unique(ds$rain_tomorrow))
  tds <- merge(tds, rattle::digitDistr(ds[ds$rain_tomorrow==i, "min_temp"], digit, len, i))

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
  ggtitle("Digital Analysis of First Digit of min_temp by rain_tomorrow") +
  ggplot2::xlab(paste("Digits\n\n", paste("RattleNG 2024-11-20 15:35:27", username), sep="")) +
  theme_default()

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
