# Rattle Scripts: From dataset ds build a neural network.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-07-20 14:58:29 +1000 Graham Williams>
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
# Author: Zheyuan Xu

# Set CRAN mirror to Australia (Canberra) [https] (Mirror number 2)
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# Check if NeuralNetTools is installed, if not, install it
if (!requireNamespace("NeuralNetTools", quietly = TRUE)) {
  install.packages("NeuralNetTools")
}

# Load necessary libraries
library(nnet)       # Neural networks
library(NeuralNetTools)  # For neural network plotting

# Define model type and description
mtype <- "neuralnet"
mdesc <- "Neural Network"

# Train a Neural Network model using nnet
model_nn <- nnet(
  form,
  data = ds[tr, vars],
  size = HIDDEN_NEURONS,        # Number of units in the hidden layer
  skip=TRUE, MaxNWts=MAX_NWTS, trace=FALSE, maxit=MAXIT
)

# Generate a textual view of the Neural Network model
print(model_nn)
summary(model_nn)
cat("\n")

# If you need to save the plot to SVG
svg("TEMPDIR/model_nn.svg")
plotnet(model_nn)
dev.off()
