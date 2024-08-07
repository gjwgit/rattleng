# Rattle Scripts: Visual Displays
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-08-01 11:40:55 +1000 Graham Williams>
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

########################################################################
# BOX PLOT
########################################################################

# Display box plot for the selected variable.

svg("TEMPDIR/explore_visual_boxplot.svg", width=10)

ds %>%
  dplyr::mutate(GROUP_BY_VAR=as.factor(GROUP_BY_VAR)) %>%
  ggplot2::ggplot(ggplot2::aes(y=SELECTED_VAR)) +
  ggplot2::geom_boxplot(ggplot2::aes(x="All"), notch=TRUE, fill="grey") +
  ggplot2::stat_summary(ggplot2::aes(x="All"), fun=mean, geom="point", shape=8) +
  ggplot2::geom_boxplot(ggplot2::aes(x=GROUP_BY_VAR, fill=GROUP_BY_VAR), notch=TRUE) +
  ggplot2::stat_summary(ggplot2::aes(x=GROUP_BY_VAR), fun=mean, geom="point", shape=8) +
  ggplot2::xlab(paste("GROUP_BY_VAR\n\n", "TIMESTAMP", sep="")) +
  ggplot2::ggtitle("Distribution of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::theme(legend.position="none") +
  theme_rattle()

dev.off()

########################################################################
# DENSITY
########################################################################

svg("TEMPDIR/explore_visual_density.svg", width=10)

ds %>%
  dplyr::mutate(GROUP_BY_VAR=as.factor(GROUP_BY_VAR)) %>%
  dplyr::select(SELECTED_VAR, GROUP_BY_VAR) %>%
  ggplot2::ggplot(ggplot2::aes(x=SELECTED_VAR)) +
  ggplot2::geom_density(lty=3) +
  ggplot2::geom_density(ggplot2::aes(fill=GROUP_BY_VAR, colour=GROUP_BY_VAR), alpha=0.55) +
  ggplot2::xlab(paste("SELECTED_VAR\n\n", "TIMESTAMP", sep="")) +
  ggplot2::ggtitle("Distribution of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::labs(fill="GROUP_BY_VAR", y="Density") +
  theme_rattle()

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
  ggplot2::xlab(paste("SELECTED_VAR\n\n", "TIMESTAMP", sep="")) +
  ggplot2::ggtitle("Empirical Cumulative Distribution of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::labs(fill="GROUP_BY_VAR", y=expression("ECDF - Proportion <= x")) +
  theme_rattle()

dev.off()

########################################################################
# BENFORD'S LAW 
########################################################################

# Initialies the parameters.

digit  <- 1
len    <- 1

# Build the dataset

tds <- merge(rattle::benfordDistr(digit, len),
             rattle::digitDistr(ds$SELECTED_VAR, digit, len, "All"))

for (i in unique(ds$GROUP_BY_VAR))
  tds <- merge(tds, rattle::digitDistr(ds[ds$GROUP_BY_VAR==i, "SELECTED_VAR"], digit, len, i))

# Plot the digital distribution

svg("TEMPDIR/explore_visual_benford.svg", width=10)

tds %>% plotDigitFreq() +
  ggtitle("Digital Analysis of First Digit of SELECTED_VAR by GROUP_BY_VAR") +
  ggplot2::xlab(paste("Digits\n\n", "TIMESTAMP", sep="")) +
  theme_rattle()

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
