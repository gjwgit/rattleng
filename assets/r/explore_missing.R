# Rattle Scripts: Missing Analysis.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-12-24 09:48:39 +1100 Graham Williams>
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

# Summary of <MISSING> in the dataset.
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials
#
# https://survivor.togaware.com/datascience/

# TODO 20240829 gjw TEMP FIX FOR <IGNORE> <HANDLING>

tds <- ds[setdiff(vars,ignore)]

####################################
# MICE :: MD.PATTERNS
####################################

# 20240718 gjw Generate a summary of the missing values in the
# dataset.
#
# 20250812 gjw Transpose the table as this is generally more compact,
# with the variables down the left and the columns are the patterns of
# missing values.
#
# 20251224 gjw Generate this plot but don't show it as I will show the
# ggplot2 version instead now.

# Report the patterns of missing values as a table.
#
# 20260817 gjw The table is turned on its side from the way `md.pattern()`
# reports it, one row per variable rather than one column per variable. A
# dataset of any width has far more variables than fit across a page, and
# `md.pattern()` printed as it comes wraps into several blocks, each with its
# own header, which is hard to read. There are only ever a handful of
# patterns, so a column each for those always fits.
#
# The two counts that `md.pattern()` puts at the edges of the table are
# brought to the top and labelled, since a bare row of numbers with no
# heading is not much use to anyone.
#
# Anyone changing the shape of this table: the description of it in
# `lib/features/missing/display.dart` names these rows and columns, and has
# to be changed with it.

missing_pattern_table <- function(md) {

  npat  <- nrow(md) - 1
  nvars <- ncol(md) - 1

  vars      <- colnames(md)[1:nvars]
  obs       <- rownames(md)[1:npat]
  nmiss_pat <- md[1:npat, nvars + 1]
  nmiss_var <- md[npat + 1, 1:nvars]
  total     <- md[npat + 1, nvars + 1]

  # One row per variable and one column per pattern.

  grid <- t(md[1:npat, 1:nvars, drop=FALSE])

  labels <- c("Count of Observations", "Number Missing", "", vars)

  cells <- rbind(as.character(obs),
                 as.character(nmiss_pat),
                 rep("", npat),
                 matrix(as.character(grid), nrow=nvars))

  right <- c("", as.character(total), "", as.character(nmiss_var))

  # Widen each column to its widest entry so that the columns line up.

  lw <- max(nchar(labels))
  cw <- apply(cells, 2, function(column) max(nchar(column)))
  rw <- max(nchar(right))

  for (i in seq_along(labels))
  {
    line <- paste0(formatC(labels[i], width=-lw), "  ",
                   paste(mapply(function(cell, width)
                                  formatC(cell, width=width),
                                cells[i, ], cw), collapse=" "), "  ",
                   formatC(right[i], width=rw))

    cat(sub("[ ]+$", "", line), "\n", sep="")
  }

  invisible(md)
}

# The plot is drawn as a side effect of `md.pattern()` and so goes to the
# device opened here, while the table it returns is reported above.

svg("<TEMPDIR>/explore_missing_mice_original.svg")
missing_pattern_table(mice::md.pattern(tds, rotate.names=TRUE))
dev.off()

####################################
# MICE :: MD.PATTERNS WITH GGPLOT2
####################################

# 20251224 gjw A missing values plot using ggplot2. It is a little
# nicer than the default plot and we can control it a little more
# through ggplot2.

create_md_pattern_plot <- function(data) {

  # Get the missing data pattern matrix from mice.

  pattern_matrix <- mice::md.pattern(data, plot = FALSE)

  # Extract the pattern part (exclude the count column and missing
  # count row).

  n_vars <- ncol(data)
  n_patterns <- nrow(pattern_matrix) - 1

  # Get just the pattern matrix without totals.

  patterns <- pattern_matrix[1:n_patterns, 1:n_vars]
  counts <- pattern_matrix[1:n_patterns, n_vars + 1]

  # Create a data frame for ggplot.  Each row represents a variable,
  # each column represents a pattern.

  plot_data <- expand.grid(
    Variable = factor(colnames(patterns), levels=rev(colnames(patterns))),
    Pattern  = factor(1:n_patterns, levels=1:n_patterns)
  )

  # Add the missing/observed values (transposed).

  plot_data$Value <- as.vector(t(patterns))
  plot_data$Missing <- factor(plot_data$Value,
                              levels = c(0, 1),
                              labels = c("Missing", "Observed"))

  # Add pattern counts for labeling.

  pattern_counts <- data.frame(
    Pattern = factor(1:n_patterns),
    Count   = counts,
    y_pos   = length(colnames(patterns)) + 0.5
  )

  # Create the plot.

  p <- ggplot(plot_data, aes(x = Pattern, y = Variable, fill = Missing)) +

  geom_tile(color = "white", linewidth = 0.5) +

  # Add count labels at the top.

  geom_text(
    data = pattern_counts,
    aes(x = Pattern, y = y_pos + 0.3, label = Count),
    inherit.aes = FALSE,
    size = 3.5,
    fontface = "bold"
  ) +

  # Add missing count for each variable on the right.

  geom_text(
    data = data.frame(
      Variable = factor(colnames(patterns), levels = colnames(patterns)),
      x_pos = n_patterns + 1.0,
      MissingCount = colSums(is.na(data))[colnames(patterns)]
    ),
    aes(x = x_pos, y = Variable, label = MissingCount),
    hjust = 0,
    # nudge_x = 1.0,
    inherit.aes = FALSE,
    size = 3.5,
    fontface = "bold"
  ) +

  # Ensure we have space to display the count column.

  coord_cartesian(xlim = c(0, n_patterns + 1)) +

  <SETTINGS_GRAPHIC_THEME>() +

  theme(
    axis.text.x = element_text(angle = 0),
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10)),
    legend.position = "bottom",
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5)
  ) +

  labs(
    title = "Missing Data Pattern",
    x = "Missing Data Pattern",
    y = "Variables",
    fill = "Data Status",
    caption = "Numbers at top show number of variables with missing, numbers at right show missing count per variable"
  ) +

  # Extend the plot area to accommodate labels

  scale_x_discrete(expand = expansion(add = c(0, 1))) +
  scale_y_discrete(expand = expansion(add = c(0, 1)))

  return(p)
}

# 20251224 gjw I choose this one as the default to show for now whilst
# creating the other two as well which will be available in /tmp if
# the user wants to see them.

svg("<TEMPDIR>/explore_missing_mice.svg")
create_md_pattern_plot(tds)
dev.off()

####################################
# MICE :: MISSING PLOT WITH DOTS/CROSSES
####################################

# 20251224 gjw An alternative missing values plot using ggplot2 with
# dots and crosses instead of squares.

create_md_pattern_plot_alt <- function(data) {
  pattern_matrix <- mice::md.pattern(data, plot = FALSE)

  n_vars <- ncol(data)
  n_patterns <- nrow(pattern_matrix) - 1

  patterns <- pattern_matrix[1:n_patterns, 1:n_vars]
  counts <- pattern_matrix[1:n_patterns, n_vars + 1]

  plot_data <- expand.grid(
    Variable = factor(colnames(patterns), levels = rev(colnames(patterns))),
    Pattern = factor(1:n_patterns, levels = 1:n_patterns)
  )

  plot_data$Value <- as.vector(t(patterns))
  plot_data$Missing <- factor(plot_data$Value, levels = c(0, 1), labels = c("Missing", "Observed"))

  pattern_counts <- data.frame(
    Pattern = factor(1:n_patterns),
    Count = counts,
    y_pos = length(colnames(patterns)) + 0.5
  )

  p <- ggplot(plot_data, aes(x=Pattern, y=Variable, color=Missing, shape=Missing)) +

    geom_point(size = 8) +

    scale_color_manual(
      values = c("Missing" = "#e31a1c", "Observed" = "#1f78b4"),
      name = "Data Status"
    ) +

    scale_shape_manual(
      values = c("Missing" = 4, "Observed" = 16),  # X for missing, circle for observed
      name = "Data Status"
    ) +

    geom_text(
      data = pattern_counts,
      aes(x = Pattern, y = y_pos, label = Count),
      color = "black",
      inherit.aes = FALSE,
      size = 4,
      fontface = "bold"
    ) +

    geom_text(
      data = data.frame(
        Variable = factor(colnames(patterns), levels = colnames(patterns)),
        x_pos = n_patterns + 0.5,
        MissingCount = colSums(is.na(data))[colnames(patterns)]
      ),
      aes(x = x_pos, y = Variable, label = MissingCount),
      inherit.aes = FALSE,
      color = "black",
      size = 4,
      fontface = "bold"
    ) +


  <SETTINGS_GRAPHIC_THEME>() +

  theme(
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
  ) +

  labs(
    title = "Missing Data Pattern (Alternative Style)",
    x = "Missing Data Pattern",
    y = "Variables",
    caption = "X = Missing, • = Observed"
  ) +

  scale_x_discrete(expand = expansion(add = c(0, 1))) +
  scale_y_discrete(expand = expansion(add = c(0, 1)))

  return(p)
}

# Display the alternative version with dots and crosses.

svg("<TEMPDIR>/explore_missing_mice_dots_crosses.svg")
create_md_pattern_plot_alt(tds)
dev.off()

####################################
# VIM :: AGGREGATION
####################################

svg("<TEMPDIR>/explore_missing_vim.svg", width=16)
VIM::aggr(tds,
          bars  = TRUE,
          numbers=TRUE,
          prop=FALSE,
          combined=FALSE,
          varheight=FALSE,
          only.miss=TRUE,
          border='white',
          sortVars=TRUE,
          sortCombs=TRUE,
          labels=names(tds),
          cex.axis = .6,
          gap      = 3,
          ylabs     = c("Proportion of Values Missing",
                        "Proportions of Combinations of Missing Values"))
dev.off()

####################################
# NANIAR
####################################

# Visualize a heatmap of missing values

svg("<TEMPDIR>/explore_missing_naniar_vismiss.svg", width=16)
tds %>%
  naniar::vis_miss()
dev.off()

# 20240815 gjw Visualize the proportion of missing values in each
# variable. We could add a configuration here to display percentages
# rather than counts. `show_pct=TRUE`

svg("<TEMPDIR>/explore_missing_naniar_ggmissvar.svg", width=16)
naniar::gg_miss_var(tds)
dev.off()

# Visualize missing data using an UpSet plot

svg("<TEMPDIR>/explore_missing_naniar_ggmissupset.svg", width=16)
naniar::gg_miss_upset(tds)
dev.off()

####################################
# CORRELATION OF MISSING VALUES
####################################

# Generate a correlation plot for the variables with missing values.

svg("<TEMPDIR>/explore_missing_correlation.svg")
ds[unique(unique(inputs, risk), target)] %>%
  dplyr::select_if(~any(is.na(.))) %>%
  dplyr::mutate(dplyr::across(tidyselect::everything(), ~as.numeric(is.na(.)))) ->
dsm
corm <- cor(dsm, use = "complete.obs")
corrplot::corrplot(corm,
                   method = "ellipse",
                   order  = "hclust",
                   type   = "full",
                   tl.srt = 45,
                   tl.col = "black",
                   mar    = c(0,0,1,0))
title(main = glue("Correlation of Missing Values {basename('<FILENAME>')} using Pearson"),
      sub  = paste("<TIMESTAMP>", username))
dev.off()
