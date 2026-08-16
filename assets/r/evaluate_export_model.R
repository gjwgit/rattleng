# Add one model's predictions to the evaluation results being exported.
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

# Each model contributes its own columns, named for the model, so that
# the models can be compared row by row. `mtype` names the model and is
# set by the `evaluate_model_*` script that precedes this one.

if (! exists("export_result"))
{
  cat("EXPORT FAILED: the export was not started.\n")
} else {

  export_result[[paste0(mtype, "_predicted")]] <- predicted

  # A probability belongs to a classification, where the model is
  # choosing between the levels of the target. Predicting a number has
  # no probability to report, and there `prob_ra()` simply repeats the
  # prediction, which is not worth a column of its own.
  #
  # 20260817 gjw The test is that the prediction is not a number, and
  # so is a class. Asking instead whether it is a factor quietly loses
  # the probability of any model that reports its classes as character
  # strings, as `nnet` does through `predict(type="class")`.

  if (! is.numeric(predicted))
    export_result[[paste0(mtype, "_probability")]] <- probability

  cat("Added the", mdesc, "predictions to the export.\n")
}
