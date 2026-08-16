# Load a dataset from file to evaluate the model against.
#
# Copyright (C) 2026, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2026-08-16 11:05:00 +1000 Graham Williams>
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

# A dataset of observations that the model has never seen gives the
# most honest estimate of how the model will perform in use. Here we
# load such a dataset from its own file, as `evalds`, to evaluate the
# model against, rather than using a partition of the dataset the
# model was built from.

evalds <- readr::read_csv("<EVAL_FILENAME>", show_col_types=FALSE) %>%
  as.data.frame()

# Normalise the variable names exactly as they were normalised for the
# training dataset, so that the two agree on what each variable is
# called.

if (<NORMALISE_NAMES>)
{
  evalds %<>% janitor::clean_names(numerals="right")
}

# Match each variable to the way it is represented in the dataset the
# model was trained on. A model will not predict from a character
# string where it was trained on a factor, and a factor carrying only
# the levels that happen to appear in this file is not the factor the
# model knows, so the levels are taken from the training dataset. A
# level here that the model never saw becomes NA rather than an error.

for (v in if (exists("ds")) intersect(names(evalds), names(ds)) else c())
{
  if (is.factor(ds[[v]]))
    evalds[[v]] <- factor(evalds[[v]], levels=levels(ds[[v]]))
  else if (is.numeric(ds[[v]]))
    evalds[[v]] <- as.numeric(evalds[[v]])
}

if (! exists("ds"))
  cat("NO DATASET: load a dataset and build a model before evaluating.\n")

# Report on what was loaded, and on anything the model will ask for
# that this dataset does not have, since that is the usual reason an
# evaluation of a loaded dataset fails.

cat("Loaded", nrow(evalds), "observations of", ncol(evalds), "variables.\n")

if (exists("tcds"))
{
  evalds_missing <- setdiff(setdiff(names(tcds), c(target, risk)), names(evalds))

  if (length(evalds_missing) > 0)
    cat("MISSING model inputs:", paste(evalds_missing, collapse=", "), "\n")
}

# The actual values of the TARGET and the RISK variables, which the
# evaluation measures compare the predictions against. Without a
# target we can predict but we cannot measure how good the model is.

if (exists("target") && !is.null(target) && target %in% names(evalds))
{
  actual_ld <- evalds[[target]]
} else {
  actual_ld <- NULL
  cat("NO TARGET: the dataset has no",
      if (exists("target")) target else "target variable",
      "so the model can be applied but not measured.\n")
}

if (exists("risk") && !is.null(risk) && risk %in% names(evalds))
{
  risk_ld <- as.numeric(evalds[[risk]])
} else {
  risk_ld <- NULL
}
