# Begin the export of the evaluation results, one row per observation.
#
# Copyright (C) 2026, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2026-08-16 12:30:00 +1000 Graham Williams>
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

# Start the table that the results are exported from: the observations
# of whichever dataset was evaluated, and the value we were trying to
# predict. The models then each add their own predictions to it, so
# that the one file compares them over the very same observations.

# The preceding evaluate template has named the dataset it worked over
# in `dtype`. Recover it from that rather than from the templates
# themselves, which are shared with every evaluation measure and so are
# not ours to change.

export_ds <- switch(dtype,
                    training   = trds,
                    tuning     = tuds,
                    validation = tuds,
                    testing    = teds,
                    complete   = tcds,
                    loaded     = evalds,
                    NULL)

if (is.null(export_ds))
{
  cat("EXPORT FAILED: no dataset for the", dtype, "evaluation.\n")

  if (exists("export_result")) rm(export_result)

} else {

  export_result <- export_ds

  # The target and risk variables are dropped from the observations
  # here and added back below as `actual` and `risk`. They would
  # otherwise appear twice, once under their own name among the
  # observations and again as the outcome, holding the very same
  # values. Naming them for what they are also keeps the outcome
  # columns together at the end of the file, whatever the dataset
  # happens to call them.

  if (exists("target") && ! is.null(target))
    export_result[[target]] <- NULL

  if (exists("risk") && ! is.null(risk))
    export_result[[risk]] <- NULL

  # The actual outcome appears once, no matter how many models go on to
  # predict it. A dataset loaded without the target variable has no
  # actual outcome to compare against, so the column is simply absent
  # and the file reports what the models predict.

  if (! is.null(actual_va))
    export_result$actual <- actual_va
  else
    cat("No actual values: the export will carry the predictions only.\n")

  if (! is.null(risk_va)) export_result$risk <- risk_va
}
