# Setup a new Rattle session.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2025-01-06 06:58:47 +1100 Graham Williams>
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

# TIMESTAMP
#
# The concept of templates for data science was introduced in The
# Essentials of Data Science, 2017, CRC Press, referenced throughout
# this script as @williams:2017:essentials
# (https://bit.ly/essentials_data_science). On-line examples are
# available from the Data Science Desktop Survival Guide
# https://survivor.togaware.com/datascience/.

####################################
# Load/Install Required Packages
####################################

# We begin most scripts by loading the required packages.  Here are
# some initial packages to load and others will be identified as we
# proceed through the script. When writing our own scripts we often
# collect together the library commands at the beginning of the script
# here.

# 20241007 gjw Loading packages requires they are already installed
# into a local library. The RattleNG installation instructions
# recommends installing these packages before running rattle for the
# first time. From within RattleNG, tap the DOWNLOAD button in the top
# right button bar which will run the `packages.R` script to check and
# install any missing packages.

library(ggplot2) # To support a local rattle theme.
library(ggtext)  # To support markdown text in ggplot title.


####################################
# Default settings
####################################

# The crayon package in R is used to produce highlighted and
# emboldened output to the console. We turn off the fancy terminal
# escape sequences here. These tend to make the parsing of the text
# output presented to STDOUT somewhat challenging for Rattle.

options(crayon.enabled = FALSE)

# TODO 20241007 gjw MOVE WIDTH LITERAL INTO SETTINGS

# Set the width wider than the default 80. Experimentally, on Linux,
# MacOS, Windows, seems like 120 works, though it depends on font size
# etc. Also we now 20240814 have horizontal scrolling on the TextPage.

options(width=120)

# TODO 20241007 gjw MOVE SEED LITERAL INTO SETTINGS

# A pre-defined value for the random seed. Setting the random seed to
# a specific known value ensures that the processing and analyses
# undertaken in Rattle are repeatable every time. Usually, with a
# different random seed each time R starts up we get different
# results, like different partitioning, differe trees, etc.

set.seed(RANDOM_SEED)

####################################
# Support Functions
####################################

# TODO 20241007 gjw MOVE R SUPPORT FUNCTIONS INTO RATTLE R PACKAGE
#
# Or else are there equivalent functions in other packages.

library(jsonlite)
library(lubridate)    # Check if variable is a date.

# A function to provide the dataset summary as JSON which can then be
# parsed by Rattle as the dataset summary from which Rattle gets all
# of it's meta data.

meta_data <- function(df) {
  summary_list <- lapply(names(df), function(var_name) {
    x <- df[[var_name]]
    if (is.numeric(x)) {
      list(
        datatype = "numeric",
        min = min(x, na.rm = TRUE),
        max = max(x, na.rm = TRUE),
        mean = mean(x, na.rm = TRUE),
        median = median(x, na.rm = TRUE),
        variance = var(x, na.rm = TRUE),
        unique = length(unique(x)),
        missing = sum(is.na(x))
      )
    } else if (is.factor(x)) {
      list(
        datatype = "factor",
        unique = length(unique(x)),
        missing = sum(is.na(x))
      )
    } else if (is.character(x)) {
      list(
        datatype = "character",
        min = min(x, na.rm = TRUE),
        max = max(x, na.rm = TRUE),
        unique = length(unique(x)),
        missing = sum(is.na(x))
      )
    } else if (lubridate::is.Date(x)) {
      list(
        datatype = "date",
        min = min(x, na.rm = TRUE),
        max = max(x, na.rm = TRUE),
        unique = length(unique(x)),
        missing = sum(is.na(x))
      )
    } else {
      list(
        datatype = "other",
        unique = length(unique(x)),
        missing = sum(is.na(x)),
      )
    }
  })

  # Name the list elements by the variable names

  names(summary_list) <- names(df)

  # Convert the list to a JSON string.

  json_output <- jsonlite::toJSON(summary_list, pretty = TRUE)
  return(json_output)
}

# Username

username <- Sys.getenv("USER")  # On Linux/MacOS
if (username == "") {
  username <- Sys.getenv("USERNAME")  # On Windows
}
##
## 20250106 gjw Introduce the `rat()` command as being excatly the
## same as the `cat()` command but is used where we don't want to
## export the command to the user's R script.
##
rat <- cat

# Check if a variable is a factor (including ordered factors) and has
# more than 20 levels.

is_large_factor <- function(x, maxfactor = 20) {
  is_cat <- is.factor(x) || is.ordered(x) || is.character(x)

  if (is.factor(x) || is.ordered(x)) {
    num_levels <- length(levels(x))
  } else if (is.character(x)) {
    num_levels <- length(unique(x))
  } else {
    num_levels <- NA  # For non-categoric variables
  }

  if (is_cat) {
    return(num_levels > maxfactor)
  }

  return(FALSE)
}

# First  check if values in a column are unique.

check_unique <- function(x) {
  !any(duplicated(x))
}

# Check if the numbers in the column are real numbers and if so return
# FALSe so they are not included in the potentiasl IDENT.

check_not_real <- function(x) {
  if (! is.numeric(x)) {
    return(TRUE)
  } else {
    return(! any(x != round(x)))
  }
}

# Then find columns with unique values which we will treat as
# identifiers, but not real number columns.

unique_columns <- function(df) {
  col_names <- names(df)
  # Get those columns that have only unique values.
  unique_cols <- col_names[sapply(df, check_unique)]
  # Remove those that are real numbers (more likely to be unique)
  unique_cols <- unique_cols[sapply(df[unique_cols], check_not_real)]
  return(unique_cols)
}

find_fewest_levels <- function(df) {
  # Select only the categoric (factor) columns from the data frame
  cat_vars <- df[, sapply(df, is.factor), drop = FALSE]

  # Check if there are any categoric variables
  if (ncol(cat_vars) > 0) {
    # Find the variable with the fewest levels
    fewest_levels_var <- names(cat_vars)[which.min(sapply(cat_vars, nlevels))]

    # Find all variables that have the fewest levels
    min_levels <- min(sapply(cat_vars, nlevels))
    fewest_levels_vars <- names(cat_vars)[sapply(cat_vars, nlevels) == min_levels]

    # Select the last variable in case of ties
    fewest_levels_var <- fewest_levels_vars[length(fewest_levels_vars)]

    # Return the variable with the fewest levels
    return(fewest_levels_var)
  } else {
    # If no categoric variables are found, return a message
    return("")
  }
}

####################################
# A Rattle Theme for Graphics
####################################

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

## MOVED TO USING SETTINGS_GRAPHIC_THEME IN SCRIPTS
## theme_default <- theme_rattle
