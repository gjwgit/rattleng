# Setup the model template variables for descriptive and predictive models.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-04-10 14:39:33 +1000 Graham Williams>
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
# Run this script after the variable `ds` (dataset) and other data
# template variables have been defined as in `data_template.R`. This
# script will initialise the model template variables including
# performing any partitioning.
#
# References:
#
# @williams:2017:essentials Chapter 7.
#
# https://survivor.togaware.com/datascience/model-template.html

# Load required packages from the local library into the R session.

library(stringi)      # The string concat operator %s+%.

# 20250202 gjw Record basic variable roles for the templates. We add
# in the risk variable and the identifier variable to the user
# specificed list of variables to ignore. The `vars` are all variables
# to retain in a dataaset for working with whilst `inputs` are the
# vars without the target (output) variable.

ignore <- c(risk, identifiers, ignore)
vars   <- setdiff(vars, ignore)
inputs <- setdiff(vars, target)

# Generate the formula to be used for predictive modelling which is
# available when a TARGET variable is identified.

if (!is.null(target)) {
  form <- formula(target %s+% " ~ .")

  # 20250108 gjw Create the Target complete dataset (tcds).  We
  # identify a subset of the full dataset that has values for the
  # target variable, removing those rows that do not have a
  # target. For predictive modelling we would only use data that has a
  # target value.

  # 20250115 gjw Note that this is different to the default for V5
  # which leaves the missing targets in the dataset.

  tcds <- ds[!is.na(ds[[target]]),]
} else {
  form <- formula("~ .")

  # If no TARGET variable is identified then we still want to start
  # with a `tcds` for processing.

  tcds <- ds
}

# parrty::ctree() cannot handle predictors of type character.  Convert
# character columns to factors. 20250116 gjw This may not be the case
# with the newer partykit package. Try not for now.

# tcds <- tcds %>%
#   dplyr::mutate(across(where(is.character), as.factor))

print(form)

# Update the number of `obs` which is needed for the partitioning.

tcnobs <- nrow(tcds)

# Do we want to partition the dataset?

partitioning <- <SPLIT_DATASET>

# Split the dataset into train, tune/validate, and test, recording
# the indicies of the observations to be associated with each
# dataset. If the dataset is not to be partitioned, simply have the
# train, tune/validate and test datasets as the whole dataset.

if (partitioning) {

  # To get the same model each time we partition the dataset the same
  # way each time based on a fixed seed that the user can override to
  # explore the impact of different dataset paritioning on the
  # resulting model.
  ##
  ## TODO 20241202 gjw <REPLACE> THE <FIXED> 42 WITH A <SETTINGS> <VALUE> FOR THE SEED.
  ##
  ## TODO 20241202 gjw ADD <PROVIDER> FOR <RANDOM_PARTITION> TO <RANDOMISE> EACH TIME.
  ##
  ## TODO 20241202 gjw <MAYBE> IF <RANDOM_SEED> IS <EMPTY> WE <RANDOMISE> EACH TIME HERE.

  # Do we want to have the different random partitioning each time,
  # resulting in randomly different models?

  randomly <- <RANDOM_PARTITION>

  if (! randomly) {
    set.seed(<RANDOM_SEED>)
  }

  # Specify the three way split for the dataset: <TRAINING> (tr) and
  # <TUNING> (tu) and <TESTING> (te).

  split <- c(<DATA_SPLIT_TR_TU_TE>)

  # 20250122 gjw Build the indicies for the different datasets:
  # complete, train, tune, and test.

  tc <- 1:tcnobs
  tr <- tcnobs %>% sample(split[1]*tcnobs)
  tu <- tcnobs %>% seq_len() %>% setdiff(tr) %>% sample(split[2]*tcnobs)
  te <- tcnobs %>% seq_len() %>% setdiff(tr) %>% setdiff(tu)

} else {

  # If the user has decided not to partition the data we will build
  # the model and tune/test the model on the same dataset. This is not
  # good practice as the tuning and testing will deliver very
  # optimistic estimates of the model performance.

  tc <- tr <- tu <- te <- 1:tcnobs
}

# Note the actual values of the TARGET variable and the RISK variable
# for use in model training and evaluation later on.

if (!is.null(target)) {
  actual_tc <- tcds %>% dplyr::slice(tc) %>% pull(target)
  actual_tr <- tcds %>% dplyr::slice(tr) %>% pull(target)
  actual_tu <- tcds %>% dplyr::slice(tu) %>% pull(target)
  actual_te <- tcds %>% dplyr::slice(te) %>% pull(target)
}

if (!is.null(risk)) {
  risk_tc <- tcds %>% dplyr::slice(tc) %>% pull(risk)
  risk_tr <- tcds %>% dplyr::slice(tr) %>% pull(risk)
  risk_tu <- tcds %>% dplyr::slice(tu) %>% pull(risk)
  risk_te <- tcds %>% dplyr::slice(te) %>% pull(risk)
}

# Check if the risk variable exists and create `risk_tc`. We do this
# here before we remove the risk variable (part of the `ignore` list).

if (!is.null(risk)) {
  # Retrieve the risk values for the full dataset.

  risk_tc <- tcds %>%
    pull(risk) %>%
    as.numeric()  # Ensure it's numeric.

  # 20250108 gjw We used to handle NA risk values by replacing them
  # with a default value (e.g., 0). For now let's not do that.

  risk_tc <- ifelse(is.na(risk_tc) | is.nan(risk_tc), 0, risk_tc)
} else {
  # If no risk, set `risk_tc` to NULL.

  risk_tc <- NULL
}

# Retain only the columns that we need for the predictive modelling.
# ctree() from the party package cannot handle predictors of type
# character so convert character columns to factors.  The aim is to
# ensure feature names stored in `object` and `newdata` are the same.

tcds <- tcds[tc, setdiff(vars, ignore)] %>%
  dplyr::mutate(across(where(is.character), as.factor))

trds <- tcds[tr, setdiff(vars, ignore)] %>%
  dplyr::mutate(across(where(is.character), as.factor))

tuds <- tcds[tu, setdiff(vars, ignore)] %>%
  dplyr::mutate(across(where(is.character), as.factor))

teds <- tcds[te, setdiff(vars, ignore)] %>%
  dplyr::mutate(across(where(is.character), as.factor))

# TODO 20250122 gjw REVIEW WHY IT IS NEEDED AND EXPLAIN IT.

if (!is.null(target)) {

  # Convert to numeric (binary if applicable).

  levels_actual <- unique(actual_tc)
  actual_numeric_tc <- ifelse(actual_tc == levels_actual[1], 0, 1)

} else {
  # If no target, set `actual_tc` to NULL.

  actual_tc <- NULL
  actual_numeric_tc <- NULL
}
##
## Add a set.seed here if RANDOM_MODEL (a new setting) is FALSE. If
## TRUE then we don't reset the seed for building a model. If it is
## FALSE (i.e., no radmoniser) then we do set.seed() for the model
## build. (gjw 20250409)

## THE FOLLOWING NEEDS TO BE UPDATED IN RATTLE ITSELF

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
  cat(sprintf("> Number of Tree %d and Number of rules %d\n", n, nrules))
}
