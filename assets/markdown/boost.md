# Boosting Model

The basic idea of boosting is to associate a weight with each observation
in the dataset. A series of models are built and the weights are
increased (boosted) if a model incorrectly classifies the observation.
The resulting series of decision trees form an ensemble model.

The Adaptive option deploys the traditional adaptive boosting
algorithm as implemented in the adaboost package.

The Extreme option deploys the extreme gradient boosting algorithm to
build a gradient boosting model which is an optimal approach to
boosting. The implementation of the xgboost package is
used.
