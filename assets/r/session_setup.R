# Setup a new Rattle session.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-04-24 16:52:39 +1000 Graham Williams>
#
# Rattle version <VERSION>.
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

# <TIMESTAMP>
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

# Loading packages requires they are already installed
# into a local library. The RattleNG installation instructions
# recommends installing these packages before running rattle for the
# first time. From within RattleNG, tap the <DOWNLOAD> button in the top
# right button bar which will run the `packages.R` script to check and
# install any missing packages. (20241007 gjw)

library(ggplot2)      # To support a local rattle theme.
library(ggtext)       # To support markdown text in ggplot title.
library(glue)         # To glue strings together.
library(rattle)       # Support functions used throughout data science.
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().

####################################
# Default settings
####################################

# The crayon package in R is used to produce highlighted and
# emboldened output to the console. We turn off the fancy terminal
# escape sequences here. These tend to make the parsing of the text
# output presented to <STDOUT> somewhat challenging for Rattle.

options(crayon.enabled = FALSE)

# TODO 20241007 gjw MOVE <WIDTH> <LITERAL> INTO <SETTINGS>
##
# Set the width wider than the default 80. Experimentally, on Linux,
# MacOS, Windows, seems like 120 works, though it depends on font size
# etc. Also we now 20240814 have horizontal scrolling on the TextPage.

options(width=120)

# TODO 20241007 gjw MOVE SEED <LITERAL> INTO <SETTINGS>
##
# A pre-defined value for the random seed. Setting the random seed to
# a specific known value ensures that the processing and analyses
# undertaken in Rattle are repeatable every time. Usually, with a
# different random seed each time R starts up we get different
# results, like different partitioning, differe trees, etc.

set.seed(<RANDOM_SEED>)

####################################
# Support Functions
####################################

# The following support functions are planned to be migrated into the
# rattle package in R and so will not be required here.
##
## Be sure to first check if there are equivalent functions in other
## packages in the tidyverse.

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
    } else if (lubridate::is.Date(x) || lubridate::is.POSIXct(x)) {
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
        missing = sum(is.na(x))
      )
    }
  })

  # Name the list elements by the variable names

  names(summary_list) <- names(df)

  # Convert the list to a JSON string.

  json_output <- jsonlite::toJSON(summary_list, pretty = TRUE)
  return(json_output)
}

# The username is used for xlab() in ggplot() and within subtitles for
# plots.

username <- Sys.getenv("USER")  # On Linux and macOS
if (username == "") username <- Sys.getenv("USERNAME")  # On Windows
##
## Introduce the `rat()` command as being excatly the same as the
## `cat()` command but is used where we don't want to export the
## command to the user's R script. (20250106 gjw)
##
rat <- cat

# Check if values in a column are unique.

check_unique <- function(x) {
  !any(duplicated(x))
}

# Check if the numbers in the column are real numbers and if so return
# FALSe so they are not included in the potentiasl <IDENT>.

check_not_real <- function(x) {
  if (! is.numeric(x)) {
    return(TRUE)
  } else {
    return(! any(x != round(x)))
  }
}

# Identify columns (except real numbers) with unique values to treat
# as identifiers. (20250311 gjw)

unique_columns <- function(tbl) {
  tbl %>%
    dplyr::select(where(~ !is.numeric(.x) || all(.x == as.integer(.x), na.rm=TRUE))) ->
  non_real_cols

  non_real_cols %>%
    dplyr::select(where(~ dplyr::n_distinct(.x, na.rm=TRUE) == nrow(tbl))) %>%
    colnames() ->
  unique_non_real_cols

  return(unique_non_real_cols)
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

## <MOVED> TO <USING> <SETTINGS_GRAPHIC_THEME> IN <SCRIPTS>
## theme_default <- theme_rattle

## THE FOLLWOING NEEDS TO BE UPDATED IN RATTLE ITSELF

# Override rattle::printRandomForest() to support max.rules.

printRandomForest <- function(model, n=1, max.rules=10, include.class=NULL,
                              format="", comment="")
{
  # include.class	Vector of predictions to include

  if (!inherits(model, "randomForest"))
    stop(Rtxt("the model is not of the 'randomForest' class"))

  if (format=="VB") comment="'"

  tr <- randomForest::getTree(model, n)
  tr.paths <- rattle:::getRFPathNodesTraverse(tr)
  tr.vars <- attr(model$terms, "dataClasses")[-1]

  ## Initialise the output

  cat(sprintf("%sRandom Forest Model %d", comment, n), "\n\n")

  ## Generate a simple form for each rule.

  cat(paste(comment,
            "-------------------------------------------------------------\n",
            sep=""))

  if (format=="VB")
    cat("IF FALSE THEN\n' This is a No Op to simplify the code\n\n")

  ## Number of rules generated

  nrules <- 0

  for (i in seq_along(tr.paths))
  {
    tr.path <- tr.paths[[i]]
    nodenum <- as.integer(names(tr.paths[i]))
    # 090925 This needs work to make it apply in the case of a
    # regression model. For now simply note this in the output.
    target <- levels(model$y)[tr[nodenum,'prediction']]

    if (! is.null(include.class) && target %notin% include.class) next()

    nrules <- nrules + 1

    if (i <= max.rules) {

    cat(sprintf("%sTree %d Rule %d Node %d %s\n \n",
                comment, n, i, nodenum,
                ifelse(is.null(target), "Regression (to do - extract predicted value)",
                       paste("Decision", target))))

    if (format=="VB") cat("ELSE IF TRUE\n")

    ## Indicies of variables in the path

    var.index <- tr[,3][abs(tr.path)] # 3rd col is "split var"
    var.names <- names(tr.vars)[var.index]
    var.values <- tr[,4][abs(tr.path)] # 4th col is "split point"

    for (j in 1:(length(tr.path)-1))
    {
      var.class <- tr.vars[var.index[j]]
      if (var.class == "character" | var.class == "factor" | var.class == "ordered")
      {
        node.op <- "IN"

        ## Convert the binary to a 0/1 list for the levels.

        var.levels <- levels(eval(model$call$data)[[var.names[j]]])
        bins <- rattle:::sdecimal2binary(var.values[j])
        bins <- c(bins, rep(0, length(var.levels)-length(bins)))
        if (tr.path[j] > 0)
          node.value <- var.levels[bins==1]
        else
          node.value <- var.levels[bins==0]
        node.value <- sprintf('("%s")', paste(node.value, collapse='", "'))
      }
      else if (var.class == "integer" | var.class == "numeric")
      {
        ## Assume spliting to the left means "<", and right ">=",
        ## which is not what the man page for getTree claims!
        if (tr.path[j]>0)
          node.op <- "<="
        else
          node.op <- ">"
        node.value <- var.values[j]
      }
      else
        stop(sprintf("Rattle E234: getRFRuleSet: class %s not supported.",
                     var.class))

      if (format=="VB")
        cat(sprintf("AND\n%s %s %s\n", var.names[j], node.op, node.value))
      else
        cat(sprintf("%d: %s %s %s\n", j, var.names[j], node.op, node.value))
    }
    if (format=="VB") cat("THEN Count = Count + 1\n")
    cat("-----------------------------------------------------------------\n")
 }
  if (format=="VB") cat("END IF\n\n")
  }
  shown <- ""
  if (max.rules < nrules) shown <- glue(". Only {max.rules} rules shown.")
  cat(sprintf("%sNumber of rules in Tree %d: %d%s\n\n", comment, n, nrules, shown))
}
