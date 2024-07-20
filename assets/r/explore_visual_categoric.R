# Rattle Scripts: For dataset ds generate visual displays.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-14 20:28:16 +1000 Graham Williams>
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
# Bar Plot 
########################################################################

svg("TEMPDIR/explore_visual_bars.svg", width=10)

# Generate the summary data for plotting.

tds <- rbind(summary(na.omit(ds$wind_gust_dir)),
    summary(na.omit(ds[ds$TARGET_VAR=="No",]$wind_gust_dir)),
    summary(na.omit(ds[ds$TARGET_VAR=="Yes",]$wind_gust_dir)))

# Sort the entries.

ord <- order(tds[1,], decreasing=TRUE)

# Plot the data.

bp <-  gplots::barplot2(tds[,ord], beside=TRUE, ylab="Frequency", xlab="wind_gust_dir", ylim=c(0, 62), col=colorspace::rainbow_hcl(3))

# Add a legend to the plot.

legend("topright", bty="n", c("All","No","Yes"),  fill=colorspace::rainbow_hcl(3))

# Add a title to the plot.

title(main="Distribution of wind_gust_dir (sample)\nby TARGET_VAR",
    sub="TIMESTAMP")

dev.off()

########################################################################
# Dot Plot 
########################################################################

svg("TEMPDIR/explore_visual_dots.svg", width=10)

# Generate the summary data for the plot.

tds <- rbind(summary(na.omit(ds$wind_gust_dir)),
    summary(na.omit(ds[ds$TARGET_VAR=="No",]$wind_gust_dir)),
    summary(na.omit(ds[ds$TARGET_VAR=="Yes",]$wind_gust_dir)))

# Sort the entries.

ord <- order(tds[1,], decreasing=TRUE)

# Plot the data.

dotchart(tds[nrow(tds):1,ord],
         main   = "Distribution of wind_gust_dir (sample)\nby TARGET_VAR",
         sub    = "TIMESTAMP",
         col    = rev(colorspace::rainbow_hcl(3)),
         labels = "",
         xlab   = "Frequency",
         ylab   = "wind_gust_dir",
         pch    = c(1:2, 19))

# Add a legend.

legend("bottomright", bty="n", c("All","No","Yes"), col=colorspace::rainbow_hcl(3), pch=c(19, 2:1))

dev.off()

########################################################################
# Mosaic Plot 
########################################################################

svg("TEMPDIR/explore_visual_mosaic.svg", width=10)

# Generate the table data for plotting.

tds <- table(ds$wind_gust_dir, ds$TARGET_VAR)

# Sort the entries.

ord <- order(apply(tds, 1, sum), decreasing=TRUE)

# Plot the data.

mosaicplot(tds[ord,],
           main  = "Mosaic of wind_gust_dir (sample) by TARGET_VAR",
           sub   = "TIMESTAMP",
           color = colorspace::rainbow_hcl(3)[-1],
           cex   = 0.7,
           xlab  = "wind_gust_dir",
           ylab  = "TARGET_VAR")

dev.off()
