# Rattle Scripts: For dataset `ds` generate useful plots of categoric variable.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-10 16:23:11 +1100 Graham Williams>
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
# Author: Graham Williams, Kevin Wang

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# Preprocess the dataset to generate a temporary dataset `tds` for the
# plots.

# If we want to ignore missing values for the group-by then we filter
# out rows in `ds` with the group-by variable having `NA`. Otherwise
# simply use the whole dataset `ds`.

if (<IGNORE_MISSING_GROUP_BY>) {
  tds <- dplyr::filter(ds, !is.na(<GROUP_BY_VAR>))
} else {
  tds <- ds
}

# Ensure the group-by variable is a factor in out temporary dataset.

tds <- dplyr::mutate(tds, <GROUP_BY_VAR>=as.factor(<GROUP_BY_VAR>))

########################################################################
# Bar Plot
########################################################################

svg("<TEMPDIR>/explore_visual_bars.svg", width=10)
tds %>%
  ggplot(aes(x = <SELECTED_VAR>, fill = <GROUP_BY_VAR>)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of <SELECTED_VAR> by <GROUP_BY_VAR>",
       sub = paste("<TIMESTAMP>", username),
       x = "<SELECTED_VAR>",
       y = "Frequency",
       fill = "<GROUP_BY_VAR>") +
  <SETTINGS_GRAPHIC_THEME>()
dev.off()

########################################################################
# Dot Plot
########################################################################

overall_freq <- as.data.frame(table(tds$<SELECTED_VAR>))
colnames(overall_freq) <- c("<SELECTED_VAR>", "Frequency")
overall_freq$<GROUP_BY_VAR> <- "Overall"

# Calculate grouped frequencies.

grouped_freq <- as.data.frame(table(tds$<SELECTED_VAR>, tds$<GROUP_BY_VAR>))
colnames(grouped_freq) <- c("<SELECTED_VAR>", "<GROUP_BY_VAR>", "Frequency")

# Combine datasets.

combined_data <- rbind(overall_freq, grouped_freq)

# Create the dot plot.

svg("<TEMPDIR>/explore_visual_dots.svg", width=10)
ggplot(combined_data, aes(y = <SELECTED_VAR>, x = Frequency, fill = <GROUP_BY_VAR>)) +
  geom_dotplot(binaxis = 'y', stackdir = 'center', position = position_dodge(0.8), dotsize = 0.5) +
  geom_segment(data = subset(combined_data, <GROUP_BY_VAR> == "Overall"),
               aes(y = <SELECTED_VAR>, yend = <SELECTED_VAR>, x = 0, xend = Frequency), color = "red", linetype = "dotted") +
  labs(title = "Frequency of <SELECTED_VAR> (Overall and Grouped by <GROUP_BY_VAR>)",
       y = "<SELECTED_VAR>",
       x = "Frequency",
       fill = "Legend") +
  <SETTINGS_GRAPHIC_THEME>()
dev.off()

## # Generate the summary data for the plot.
##
## tds <- rbind(summary(na.omit(ds$<SELECTED_VAR>)),
##     summary(na.omit(ds[ds$<GROUP_BY_VAR>=="No",]$<SELECTED_VAR>)),
##     summary(na.omit(ds[ds$<GROUP_BY_VAR>=="Yes",]$<SELECTED_VAR>)))
##
## # Sort the entries.
##
## ord <- order(tds[1,], decreasing=TRUE)
##
## # Plot the data.
##
## dotchart(tds[nrow(tds):1,ord],
##          main   = "Distribution of <SELECTED_VAR> (sample)\nby <GROUP_BY_VAR>",
##          sub    = "<TIMESTAMP>",
##          col    = rev(colorspace::rainbow_hcl(3)),
##          labels = "",
##          xlab   = "Frequency",
##          ylab   = "<SELECTED_VAR>",
##          pch    = c(1:2, 19))
##
## # Add a legend.
##
## legend("bottomright", bty="n", c("All","No","Yes"), col=colorspace::rainbow_hcl(3), pch=c(19, 2:1))
##
########################################################################
# Mosaic Plot
########################################################################

library(vcd)
library(ggplotify)

# Generate the table data for plotting.

tds <- table(tds$<SELECTED_VAR>, tds$<GROUP_BY_VAR>)

# Sort the entries.

ord <- order(apply(tds, 1, sum), decreasing=TRUE)

# Plot the data.

svg("<TEMPDIR>/explore_visual_mosaic.svg", width=10)
mosaicplot(tds[ord,],
           main  = "Mosaic of <SELECTED_VAR> (sample) by <GROUP_BY_VAR>",
           sub   = paste("<TIMESTAMP>", username),
           color = colorspace::rainbow_hcl(3)[-1],
           cex   = 0.7,
           xlab  = "<SELECTED_VAR>",
           ylab  = "<GROUP_BY_VAR>")
dev.off()
