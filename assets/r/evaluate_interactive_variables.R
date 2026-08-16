# Report the model input variables for the INTERACTIVE prediction popup.
#
# Copyright (C) 2026, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2026-08-15 10:12:00 +1000 Graham Williams>
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

# Rattle timestamp: <TIMESTAMP>

## Describe each of the model input variables so that the INTERACTIVE
## popup of the EVALUATE tab can offer the user a field per variable:
## the levels of a categoric variable become the choices of a dropdown,
## and each variable gets a starting value taken from the dataset, so
## that a prediction can be made without having to fill in every field.
##
## This is GUI plumbing rather than analysis, so it reports through
## `rat()` and is not something the user needs in their own script.

interactive_variables <- function(df, vars) {

  ## Only describe the variables the dataset actually has, so that a
  ## variable that a transform has since removed is simply skipped
  ## rather than failing the whole popup.

  vars <- vars[vars %in% names(df)]

  info <- lapply(vars, function(v) {
    x <- df[[v]]

    if (is.factor(x) || is.character(x)) {

      ## Order the levels by frequency so the most common value is the
      ## starting value, being the most representative observation.

      x <- as.factor(x)
      counts <- sort(table(x), decreasing = TRUE)

      list(datatype = "categoric",
           levels   = levels(x),
           value    = names(counts)[1])

    } else if (is.numeric(x)) {

      ## The mean is the starting value, rounded so the field is
      ## readable rather than showing every decimal place.

      list(datatype = "numeric",
           min      = signif(min(x, na.rm = TRUE), 4),
           max      = signif(max(x, na.rm = TRUE), 4),
           value    = signif(mean(x, na.rm = TRUE), 4))

    } else {

      list(datatype = "other",
           value    = as.character(x[1]))
    }
  })

  names(info) <- vars

  return(jsonlite::toJSON(info, auto_unbox = TRUE))
}

## Report through a variable so that the command that prints the JSON
## is a short and fixed line that `rExtract()` can find in the console,
## rather than a line carrying the whole list of variable names, which
## the console would wrap.

interactive_vars_json <- interactive_variables(ds, <INTERACTIVE_INPUTS>)

## The newline matters: without it R's next prompt is printed on the
## same line as the JSON, and so is captured with it.

rat(interactive_vars_json, "\n")
