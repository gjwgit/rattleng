# Rattle Scripts: For dataset ds generate visual displays.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-14 20:28:30 +1000 Graham Williams>
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
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

########################################################################
# BOX PLOT
########################################################################

# Display box plot for the selected variable. Use ggplot2 to generate
# box plot.

svg("TEMPDIR/explore_visual_boxplot.svg", width=10)

ds %>%
  dplyr::mutate(VAR_TARGET=as.factor(VAR_TARGET)) %>%
  ggplot2::ggplot(ggplot2::aes(y=min_temp)) +
  ggplot2::geom_boxplot(ggplot2::aes(x="All"), notch=TRUE, fill="grey") +
  ggplot2::stat_summary(ggplot2::aes(x="All"), fun=mean, geom="point", shape=8) +
  ggplot2::geom_boxplot(ggplot2::aes(x=VAR_TARGET, fill=VAR_TARGET), notch=TRUE) +
  ggplot2::stat_summary(ggplot2::aes(x=VAR_TARGET), fun=mean, geom="point", shape=8) +
  ggplot2::xlab(paste("VAR_TARGET\n\n", "TIMESTAMP", sep="")) +
  ggplot2::ggtitle("Distribution of min_temp by VAR_TARGET") +
  ggplot2::theme(legend.position="none")

dev.off()

########################################################################
# HISTOGRAM
########################################################################

svg("TEMPDIR/explore_visual_histogram.svg", width=10)

ds %>%
  dplyr::mutate(VAR_TARGET=as.factor(VAR_TARGET)) %>%
  dplyr::select(min_temp, VAR_TARGET) %>%
  ggplot2::ggplot(ggplot2::aes(x=min_temp)) +
  ggplot2::geom_density(lty=3) +
  ggplot2::geom_density(ggplot2::aes(fill=VAR_TARGET, colour=VAR_TARGET), alpha=0.55) +
  ggplot2::xlab(paste("min_temp\n\n", "TIMESTAMP", sep="")) +
  ggplot2::ggtitle("Distribution of min_temp by VAR_TARGET") +
  ggplot2::labs(fill="VAR_TARGET", y="Density")

dev.off()

########################################################################
# CUMMULATIVE
########################################################################

svg("TEMPDIR/explore_visual_cummulative.svg", width=10)

# Generate just the data for an Ecdf plot of the variable 'min_temp'.

eds <- rbind(data.frame(dat=ds[,"min_temp"], grp="All"),
            data.frame(dat=ds[ds$VAR_TARGET=="No","min_temp"], grp="No"),
            data.frame(dat=ds[ds$VAR_TARGET=="Yes","min_temp"], grp="Yes"))

# The 'Hmisc' package provides the 'Ecdf' function.

library(Hmisc, quietly=TRUE)

# Plot the data.

Ecdf(eds[eds$grp=="All",1], col="#E495A5", xlab="min_temp", lwd=2, ylab=expression(Proportion <= x), subtitles=FALSE)
Ecdf(eds[eds$grp=="No",1], col="#86B875", lty=2, xlab="", lwd=2, subtitles=FALSE, add=TRUE)
Ecdf(eds[eds$grp=="Yes",1], col="#7DB0DD", lty=3, xlab="", lwd=2, subtitles=FALSE, add=TRUE)


# Add a legend to the plot.

legend("bottomright", c("All","No","Yes"), bty="n",  col=colorspace::rainbow_hcl(3) , lwd=2, lty=1:3, inset=c(0.05,0.05))

# Add a title to the plot.

title(main="Distribution of min_temp by VAR_TARGET", sub="TIMESTAMP")

dev.off()

########################################################################
# BENFORD'S LAW 
########################################################################

# The 'ggplot2' package provides the 'ggplot' function.

library(ggplot2, quietly=TRUE)

# The 'reshape' package provides the 'melt' function.

library(reshape, quietly=TRUE)

# Initialies the parameters.

target <- "VAR_TARGET"
var    <- "min_temp"
digit  <- 1
len    <- 1

# Build the dataset

tds <- merge(benfordDistr(digit, len),
            digitDistr(ds[var], digit, len, "All"))
for (i in unique(ds[[target]]))
  tds <- merge(tds, digitDistr(ds[ds[target]==i, var], digit, len, i))

# Plot the digital distribution

svg("TEMPDIR/explore_visual_benford.svg", width=10)
p <- plotDigitFreq(tds)
p <- p + ggtitle("Digital Analysis of First Digit of min_temp by VAR_TARGET")
p <- p + ggplot2::xlab(paste("Digits\n\n", "TIMESTAMP", sep=""))

print(p)
dev.off()

########################################################################
# PAIRS - REQUIRES TWO VARIABLES
########################################################################

# Display a pairs plot for the selected variables. 

# Use GGally's ggpairs() to do the hard work.

svg("TEMPDIR/explore_visual_pairs.svg", width=10)

ds %>%
  dplyr::mutate(VAR_TARGET=as.factor(VAR_TARGET)) %>%
  GGally::ggpairs(columns=c(3,4),
        mapping=ggplot2::aes(colour=VAR_TARGET, alpha=0.5, shape=VAR_TARGET),
                diag=list(continuous="densityDiag",
                          discrete="barDiag"),
                upper=list(continuous="cor",
                           combo="box",
                           discrete="ratio"),
                lower=list(continuous="points",
                           combo="denstrip",
                           discrete="facetbar"),
                legend=3) +
  ggplot2::theme(panel.grid.major=ggplot2::element_blank(), legend.position="right") +
  ggplot2::xlab(paste("\n\n", "TIMESTAMP", sep=""))

  
# ggplot2::scale_alpha_continuous(guide=FALSE) +
#  ggplot2::scale_fill_brewer(palette=rattlePalette) +
#  ggplot2::scale_colour_brewer(palette=rattlePalette)

dev.off()
