# Rattle Scripts: The main setup.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <2024-10-07 08:40:18 gjw>
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

# 20241001 gjw Keep R from asking to select a CRAN site and from
# asking if to create the user's local R library.  Otherwise it fails
# and the user will be awfully confused!

# options(repos = c(CRAN = "https://cloud.r-project.org"))
# options(install.packages.ask = FALSE)

# Function to install a package without prompting for library
# creation. We then use `library()` each script file to load the
# required packages from the library.

install_if_missing <- function(pkg) {

  if (!requireNamespace(pkg, character.only=TRUE, quietly=TRUE)) {


    # Specify a directory for the library

    lib_dir <- Sys.getenv("R_LIBS_USER")

    # Make sure the directory already exists so we won;t be prompted
    # to create it.
    
    if (!dir.exists(lib_dir)) {
      dir.create(lib_dir, recursive=TRUE)
      message("Package Library Created: ", lib_dir)
    }

    # Install the package without prompting for library creation

    install.packages(pkg, lib=lib_dir, dependencies=TRUE, ask=FALSE)
  }
}

# We install all packages up front so that in all likelihood any large
# install of packages happens just once and on the first startup. This
# will result in the ROLES page being blank while this happens. We
# need to pop up a message to say to check the CONSOLE as Rattle may
# be installing the required packages. For documentation suggest the
# user does the installation of the R package prior to starting
# Rattle.

# 2024-10-07 08:38 gjw This is all getting too hard to check and
# install packages within rattle for now. Instead, emphasise the need
# to install packages before rungging rattle. For Ubuntu we could add
# instructions for updating apt sources or a user installing the
# packages themselves. The latter for now.

## install_if_missing('Hmisc')
## install_if_missing('NeuralNetTools')
## install_if_missing('VIM')
## install_if_missing('corrplot')
## install_if_missing('descr')
## install_if_missing('dplyr')
## install_if_missing('fBasics')
## install_if_missing('ggcorrplot')
## install_if_missing('ggplot2')
## install_if_missing('ggthemes')
## install_if_missing('janitor')
## install_if_missing('magrittr')
## install_if_missing('mice')
## install_if_missing('naniar')
## install_if_missing('nnet')
## install_if_missing('party')
## install_if_missing('randomForest')
## install_if_missing('rattle')
## install_if_missing('readr')
## install_if_missing('reshape')
## install_if_missing('rpart')
## install_if_missing('skimr')
## install_if_missing('tidyverse')
## install_if_missing('tm')
## install_if_missing('verification')
## install_if_missing('wordcloud')

## install_if_missing('caret')
## install_if_missing('xgboost')
## install_if_missing('Matrix')
## install_if_missing('Ckmeans')
## install_if_missing('data')

# Set the width wider than the default 80. Experimentally, on Linux,
# MacOS, Windows, seems like 120 works, though it depends on font size
# etc. Also we now 20240814 have horizontal scrolling on the TextPage.

options(width=120)

# Turn off fancy terminal escape sequences that are produced using the
# crayon package.

options(crayon.enabled = FALSE)

# A pre-defined value for the random seed ensures that results are
# repeatable.

set.seed(42)

# A support function to move into rattle to provide the dataset
# summary as JSON used by RattleNG as the dataset summary from which
# RattleNG gets all of it's meta data. Note the dependency on
# jsonlite.

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
    } else if (is.factor(x) || is.character(x)) {
      list(
        datatype = "categoric",
        unique = length(unique(x)),
        missing = sum(is.na(x))
      )
    } else {
      list(
        datatype = "other",
        message = "No summary available for this type"
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

# Check if a variable is a factor (including ordered factors) and has
# more than 20 levels.

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

library(ggplot2)

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

theme_default <- theme_rattle

