# Rattle Scripts: The main setup.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2024-09-03 11:02:31 +1000 Graham Williams>
#
# Rattle version VERSION.
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

# Initialise R with required packages.
#
# The concept of templates for data science was introduced in my book,
# The Essentials of Data Science, 2017, CRC Press, referenced
# throughout this script as @williams:2017:essentials
# (https://bit.ly/essentials_data_science). On-line examples are
# available from my Data science Desktop Survival Guide
# https://survivor.togaware.com/datascience/.

# We begin most scripts by loading the required packages.  Here are
# some initial packages to load and others will be identified as we
# proceed through the script. When writing our own scripts we often
# collect together the library commands at the beginning of the script
# here.

####################################
# Load/Instal Required Packages
####################################

# 20240816 gjw How to keep R from asking to select a CRAN site?
# Sometimes I see the popup (perhaps on MacOS) and others it just
# fails.

# options(repos = c(CRAN = "https://cloud.r-project.org"))
# options(install.packages.ask = FALSE)

# Load or else install `pacman` to manage package requirements.

if(!require(pacman)) install.packages("pacman")

pacman::p_load(Hmisc,
               VIM,
               corrplot,
               descr,
               fBasics,
               ggcorrplot,
               ggthemes,
               janitor,    # Cleanup: clean_names() remove_constant().
               magrittr,   # Utilise %>% and %<>% pipeline operators.
               mice,
               naniar,
               randomForest,
               rattle,     # Access the weather dataset and utilities.
               readr,
               reshape,
               rpart,
               skimr,
               tidyverse,  # ggplot2, tibble, tidyr, readr, purr, dplyr, stringr
               tm,
               verification,
               wordcloud)

# Set the width wider than the default 80. Experimentally, on Linux,
# MacOS, Windows, seems like 120 works, though it depends on font size
# etc. Also we now 20240814 have horizontal scrolling on the TextPage.

options(width=120)

# Turn off fancy terminal escap sequences that are produced using the
# crayon package.

options(crayon.enabled = FALSE)

# A pre-defined value for the random seed ensures that results are
# repeatable.

set.seed(42)

# A support function to move into rattle to provide the one line
# summary of the dataset

meta_data <- function(df) {
  sapply(df, function(x) {
    if (is.numeric(x)) {
      paste0("min = ", min(x, na.rm = TRUE),
             ", max = ", max(x, na.rm = TRUE),
             ", mean = ", mean(x, na.rm = TRUE),
             ", median = ", median(x, na.rm = TRUE),
             ", variance = ", var(x, na.rm = TRUE),
             ", unique = ", length(unique(x)))
    } else if (is.factor(x) || is.character(x)) {
      paste0("unique = ", length(unique(x)))
    } else {
      "No summary available for this type"
    }
  })
}

# Username

username <- Sys.getenv("USER")  # On Linux/MacOS
if (username == "") {
  username <- Sys.getenv("USERNAME")  # On Windows
}


# A palette for rattle!

rattlePalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
                   "#0072B2", "#D55E00", "#CC79A7", "#000000")

# A ggplot2 theme for rattle.

theme_rattle <- function(base_size = 11, base_family = "") {
  theme_grey(base_size = base_size, base_family = base_family) +
    theme(
      # Customize text elements
      plot.title = element_text(color = "darkblue",
                                face = "bold",
                                size = base_size * 1.2),
      axis.title = element_text(color = "darkblue"),
      axis.text = element_text(color = "darkblue"),
      legend.title = element_text(color = "darkblue"),
      legend.text = element_text(color = "darkblue"),
      # Customize panel background
      panel.background = element_rect(fill = "white"),
      # Customize grid lines
      panel.grid.major = element_line(color = "lightgrey"),
      panel.grid.minor = element_line(color = "lightgrey", linetype = "dotted")
    )
}

# theme_rattle <- theme_economist
