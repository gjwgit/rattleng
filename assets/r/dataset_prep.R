# Rattle Scripts: Prepare dataset for the template: normalise, clean.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2024-10-10 08:57:09 +1100 Graham Williams>
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

# Run this after the variable `ds` (dataset) has been loaded into
# Rattle.  This script will then clean and prepare the dataset. The
# following action is the dataset template processing. We place into
# `dataset_template.R` the setup when the data within the dataset has
# changed, which may be called again after, for example, TRANSFORM.
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/data-template.html

# 20240809 gjw Move main.R here to avoid the problem on Windows where
# main.R is not getting run.

# We begin most scripts by loading the required packages.  Here are
# some initial packages to load and others will be identified as we
# proceed through the script. When writing our own scripts we often
# collect together the library commands at the beginning of the script
# here.

########################################################################
# Load required packages or install if not already.
########################################################################

# Keep R from asking to select a CRAN site.

# options(repos = c(CRAN = "https://cloud.r-project.org"))
# options(install.packages.ask = FALSE)

# 20240810 Attempt to debug the Windows issue with loading main.R on
# startup. For now on Windows we initialise here since main.R is not
# run on startup.

if (NEEDS_INIT) {

  library("Hmisc")
  library("VIM")
  library("corrplot")
  library("descr")
  library("fBasics")
  library("ggcorrplot")
  library("ggthemes")
  library("janitor")    # Cleanup: clean_names() remove_constant().
  library("jsonlite")
  library("magrittr")   # Utilise %>% and %<>% pipeline operators.
  library("mice")
  library("naniar")
  library("neuralnet")
  library("nnet")
  library("xgboost")
  library("NeuralNetTools")
  library("party")
  library("randomForest")
  library("rattle")     # Access the weather dataset and utilities.
  library("readr")
  library("reshape")
  library("rpart")
  library("skimr")
  library("tidyverse")  # ggplot2, tibble, tidyr, readr, purr, dplyr, stringr
  library("tm")
  library("verification")
  library("wordcloud")

  options(width=120)
  options(crayon.enabled = FALSE)
  set.seed(42)

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

  username <- Sys.getenv("USER")  # On Linux/MacOS
  if (username == "") {
    username <- Sys.getenv("USERNAME")  # On Windows
  }
  
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

  theme_default <- theme_rattle

  is_large_factor <- function(x, maxfactor = 20) {
    is_categorical <- is.factor(x) || is.ordered(x) || is.character(x)
  
    if (is.factor(x) || is.ordered(x)) {
      num_levels <- length(levels(x))
    } else if (is.character(x)) {
      num_levels <- length(unique(x))
    } else {
      num_levels <- NA  # For non-categorical variables
    }
    
    if (is_categorical) {
      return(num_levels > maxfactor)
    }
    return(FALSE)
  }

}

# Capture the original variable names for use in plots.

vnames <- names(ds)

# Normalise the variable names using janitor::clean_names(). This is
# done after any dataset load. The DATASET tab has an option to
# normalise the variable names on loading the data. It is set on by
# default.

if (NORMALISE_NAMES) ds %<>% janitor::clean_names(numerals="right")

# Cleanse the dataset of constant value columns and convert char to
# factor.

if (CLEANSE_DATASET) {
  # Map character columns to be factors.
  
  ds %<>% mutate(across(where(is.character),
                        ~ if (n_distinct(.) <= MAXFACTOR)
                          as.factor(.) else .))

  # Remove any constant columns,

  ds %<>% remove_constant()

  # Check if the last variable is numeric and has 5 or fewer unique
  # values then treat it as a factor since it is probably a target
  # variable. This is a little risky but perhaps worth doing. It may
  # need it's own toggle.

  # Get the name of the last column

  last_col_name <- names(ds)[ncol(ds)]

  # Check if the last column is numeric and has 5 or fewer unique values

  if (is.numeric(ds[[last_col_name]]) && length(unique(ds[[last_col_name]])) <= 5) {
    ds[[last_col_name]] <- as.factor(ds[[last_col_name]])
  }

}

# Check for unique valued columns.

# First  check if values in a column are unique.

check_unique <- function(x) {
  !any(duplicated(x))
}

# Then find columns with unique values.

unique_columns <- function(df) {
  col_names <- names(df)
  unique_cols <- col_names[sapply(df, check_unique)]
  return(unique_cols)
}

# Usage

unique_columns(ds)

find_fewest_levels <- function(df) {
  # Select only the categorical (factor) columns from the data frame
  categoric_vars <- df[, sapply(df, is.factor), drop = FALSE]
  
  # Check if there are any categorical variables
  if (ncol(categoric_vars) > 0) {
    # Find the variable with the fewest levels
    fewest_levels_var <- names(categoric_vars)[which.min(sapply(categoric_vars, nlevels))]
    
    # Find all variables that have the fewest levels
    min_levels <- min(sapply(categoric_vars, nlevels))
    fewest_levels_vars <- names(categoric_vars)[sapply(categoric_vars, nlevels) == min_levels]
    
    # Select the last variable in case of ties
    fewest_levels_var <- fewest_levels_vars[length(fewest_levels_vars)]
    
    # Return the variable with the fewest levels
    return(fewest_levels_var)
  } else {
    # If no categorical variables are found, return a message
    return("")
  }
}


# Find fewest levels

find_fewest_levels(ds)


# Index the original variable names by the new names.

names(vnames) <- names(ds)

# Display the list of vars.

names(ds)

# 20240916 gjw This is required for building the ROLES table but will
# eventually be replaced by the meta data.

glimpse(ds)
summary(ds)

# Filter the variables in the dataset that are factors or ordered factors with more than 20 levels.

large_factors <- sapply(ds, is_large_factor)

# Get the names of those variables.

large_factor_vars <- names(large_factors)[large_factors]

# Print the variable names.

large_factor_vars
