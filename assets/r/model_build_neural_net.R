# Rattle Scripts: From dataset ds build a neural network.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2024-09-23 05:27:07 +1000 Graham Williams>
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

# Load necessary libraries

library(nnet)            # Neural networks
library(NeuralNetTools)  # For neural network plotting

# Define model type and description.

mtype <- "neuralnet"
mdesc <- "Neural Network"

# Train a Neural Network model using nnet.

model_nn <- nnet(
  form,
  data = ds[tr, vars],
  size = HIDDEN_NEURONS,        # Number of units in the hidden layer
  skip=TRUE,
  MaxNWts=MAX_NWTS,
  trace=FALSE,
  maxit=MAXIT
)

# Generate a textual view of the Neural Network model.

print(model_nn)
summary(model_nn)

# Plot SVG the resulting Neural Network structure using
# NeuralNetTools.

svg("TEMPDIR/model_nn_nnet.svg")
NeuralNetTools::plotnet(model_nn,
                        cex_val=0.5,
                        circle_cex=2,
                        rel_rsc = c(1, 3),
                        pos_col="orange",
                        neg_col="grey",
                        node_labs=TRUE)
dev.off()
