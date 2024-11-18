# Random Forests

A **random forest** consists of multiple decision trees from different
samples of the dataset.  While building each tree, random subsets of
the available variables are considered for splitting the data at each
node of the tree. A simple majority vote is then used for prediction
in the case of classification and average for regression.
RandomForest's are generally robust against over fitting.

The default is to build 500 trees and to select the square root of the
number of variables as the subset to choose from at each node. The
resulting model is generally not very sensitive to the choice of these
parameters.

Any observation with missing values will be ignored, which may lead to
some surprises, like many fewer observations to model when many
missing values exist. It can also lead to losing all examples of a
particular class!

An estimate of the error rate is provided as the out-of-bag (OOB)
estimate. This applies each tree to the data that was not used in
building the tree to give a quite accurate estimate of the error rate.

The Sample Size can be used to down-sample larger classes.  For a
two-class problem with, for example, 5000 in class 0 and 250 in class
1, a Sample Size of '250, 250' will usually give a more 'balanced'
classifier.

R's
[randomForest](https://www.rdocumentation.org/packages/randomForest)
package is used to build Random Forests.
