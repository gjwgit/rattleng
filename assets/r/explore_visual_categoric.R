# Rattle Scripts: For dataset ds generate visual displays.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-07-28 05:58:39 +1000 Graham Williams>
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

if(!require(ggplot2)) install.packages("ggplot2")

########################################################################
# Bar Plot 
########################################################################

svg("TEMPDIR/explore_visual_bars.svg", width=10)

ds %>%
  ggplot(aes(x = wind_gust_dir, fill = rain_tomorrow)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of SELECTED_VAR by GROUP_BY_VAR",
       sub = "TIMESTAMP",
       x = "SELECTED_VAR",
       y = "Frequency",
       fill = "GROUP_BY_VAR") +
  theme_rattle()

dev.off()

########################################################################
# Dot Plot 
########################################################################

svg("TEMPDIR/explore_visual_dots.svg", width=10)

overall_freq <- as.data.frame(table(ds$SELECTED_VAR))
colnames(overall_freq) <- c("SELECTED_VAR", "Frequency")
overall_freq$GROUP_BY_VAR <- "Overall"

# Calculate grouped frequencies
grouped_freq <- as.data.frame(table(ds$SELECTED_VAR, ds$GROUP_BY_VAR))
colnames(grouped_freq) <- c("SELECTED_VAR", "GROUP_BY_VAR", "Frequency")

# Combine datasets
combined_data <- rbind(overall_freq, grouped_freq)

# Create the dot plot
ggplot(combined_data, aes(y = SELECTED_VAR, x = Frequency, fill = GROUP_BY_VAR)) +
  geom_dotplot(binaxis = 'y', stackdir = 'center', position = position_dodge(0.8), dotsize = 0.5) +
  geom_segment(data = subset(combined_data, GROUP_BY_VAR == "Overall"),
               aes(y = SELECTED_VAR, yend = SELECTED_VAR, x = 0, xend = Frequency), color = "red", linetype = "dotted") +
  labs(title = "Frequency of SELECTED_VAR (Overall and Grouped by GROUP_BY_VAR)",
       y = "SELECTED_VAR",
       x = "Frequency",
       fill = "Legend") +
  theme_rattle()

## # Generate the summary data for the plot.

## tds <- rbind(summary(na.omit(ds$SELECTED_VAR)),
##     summary(na.omit(ds[ds$GROUP_BY_VAR=="No",]$SELECTED_VAR)),
##     summary(na.omit(ds[ds$GROUP_BY_VAR=="Yes",]$SELECTED_VAR)))

## # Sort the entries.

## ord <- order(tds[1,], decreasing=TRUE)

## # Plot the data.

## dotchart(tds[nrow(tds):1,ord],
##          main   = "Distribution of SELECTED_VAR (sample)\nby GROUP_BY_VAR",
##          sub    = "TIMESTAMP",
##          col    = rev(colorspace::rainbow_hcl(3)),
##          labels = "",
##          xlab   = "Frequency",
##          ylab   = "SELECTED_VAR",
##          pch    = c(1:2, 19))

## # Add a legend.

## legend("bottomright", bty="n", c("All","No","Yes"), col=colorspace::rainbow_hcl(3), pch=c(19, 2:1))

dev.off()

########################################################################
# Mosaic Plot 
########################################################################

if(!require(ggplot2)) install.packages("ggplot2")
if(!require(vcd)) install.packages("vcd")
if(!require(ggplotify)) install.packages("ggplotify")

svg("TEMPDIR/explore_visual_mosaic.svg", width=10)

# Generate the table data for plotting.

tds <- table(ds$SELECTED_VAR, ds$GROUP_BY_VAR)

# Sort the entries.

ord <- order(apply(tds, 1, sum), decreasing=TRUE)

# Plot the data.

mosaicplot(tds[ord,],
           main  = "Mosaic of SELECTED_VAR (sample) by GROUP_BY_VAR",
           sub   = "TIMESTAMP",
           color = colorspace::rainbow_hcl(3)[-1],
           cex   = 0.7,
           xlab  = "SELECTED_VAR",
           ylab  = "GROUP_BY_VAR")

dev.off()
