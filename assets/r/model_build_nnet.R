# From dataset `trds` build a `nnet()` nerual model.
#
# Copyright (C) 2023-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Friday 2025-01-24 14:15:19 +1100 Graham Williams>
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
# Author: Zheyuan Xu, Graham Williams

# TIMESTAMP
#
# References:
#
# @williams:2017:essentials.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

# library(nnet)            # Neural networks
# library(NeuralNetTools)  # For neural network plotting

# Define model type and description to be used in following R scripts.

mtype <- "nnet"
mdesc <- "Neural NNET"

# 20250121 gjw The tds is set to replace trds in handling situations
# of ignoring the categoric variables (TRUE) or not (FALSE). We simply
# toggle the TRUE/FALSE here approriately.

if (<NEURAL_IGNORE_CATEGORIC>) {
  tds <- trds[setdiff(c(numc, target), ignore)]
} else {
  tds <- trds
}

# Train a Neural Network model using nnet.
##
## 20250124 gjw We would like to specify one of linout, entropy,
## softmax, censored, as TRUE but when we specify entropy we see an
## error: `formal argument "entropy" matched by multiple actual
## arguments`. It is not clear where this is coming from without
## further research for now. These options also only apply is specific
## situations that we need to test for. Not implemented for now.

model_nn <- nnet::nnet(
  form,
  data    = tds,
  size    = <NNET_HIDDEN_LAYERS>,
  skip    = <NNET_SKIP>,
  MaxNWts = <NEURAL_MAX_NWTS>,
  trace   = <NNET_TRACE>,
  maxit   = <NEURAL_MAXIT>
)

# Generate a textual view of the Neural Network model.

print(model_nn)
summary(model_nn)

# Plot SVG the resulting Neural Network structure using
# NeuralNetTools.

svg("<TEMPDIR>/model_nn_nnet.svg")
NeuralNetTools::plotnet(model_nn,
                        cex_val    = 0.5,
                        circle_cex = 2,
                        rel_rsc    = c(1, 3),
                        pos_col    = "orange",
                        neg_col    = "grey",
                        node_labs  = TRUE)
dev.off()
