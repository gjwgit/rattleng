# Predict the outcome for a single observation entered by the user.
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

# The observation to predict, as entered through the INTERACTIVE popup
# of the EVALUATE tab. This is an ordinary data frame of one row, so
# the same code serves to predict any new observation.

observation <- <INTERACTIVE_NEWDATA>

# Match each variable to the way it is represented in the dataset the
# model was trained on. A model will not predict from a character
# string where it was trained on a factor, and a factor carrying only
# the entered level is not the factor the model knows, so the levels
# are taken from the dataset itself.

for (v in names(observation))
{
  if (! v %in% names(ds))
    next
  else if (is.factor(ds[[v]]))
    observation[[v]] <- factor(observation[[v]], levels=levels(ds[[v]]))
  else if (is.numeric(ds[[v]]))
    observation[[v]] <- as.numeric(observation[[v]])
  else if (is.logical(ds[[v]]))
    observation[[v]] <- as.logical(observation[[v]])
  else
    observation[[v]] <- as.character(observation[[v]])
}

# Predict using the model set up by the preceding `evaluate_model_*`
# script, which also defines `pred_ra()` and `prob_ra()` for us, and
# describes the model in `mdesc`.

interactive_pred <- pred_ra(model, observation)

# Not every model offers a probability, and it is meaningless for a
# regression model, so a failure here is reported as no probability
# rather than as a failed prediction.

interactive_prob <- tryCatch(as.numeric(prob_ra(model, observation))[1],
                             error=function(e) NA_real_)

interactive_json <- jsonlite::toJSON(list(model       = mdesc,
                                          type        = mtype,
                                          prediction  = as.character(interactive_pred)[1],
                                          probability = interactive_prob),
                                     auto_unbox=TRUE, na="null")

## Report through a short and fixed line so that `rExtract()` can find
## the result in the console. The newline matters: without it R's next
## prompt is printed on the same line as the JSON, and so is captured
## with it.

rat(interactive_json, "\n")
