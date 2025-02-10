# Decision Trees

A **decision tree** is the prototypical data mining tool used widely
for its ease of interpretation.

A decision tree consists of a root node where the data is split into
two (for a binary tree) smaller datasets using a test on a single
variable. In turn, these two smaller datasets represent new nodes of
the tree that may then each be further split on a single (and usually
different) variable. This divide and conquer continues until no
further splitting would improve the performance of the model in
predicting the value of the target variable

While a choice of measures are available to select a variable to split
the dataset on, the Gini measure is used, and generally is no
different to the information measure for binary classification. To
explore the alternatives, copy the relevant code from the **Script**
tab and paste it into the R Console and change any of the options.

Common options that a user may change from their default values are
available.

**Priors**: used to boost a particularly important class, by giving it a
higher prior probability. Expects a list of numbers that sum up to 1,
and of the same length as the number of classes in the training dataset:
e.g.,0.5,0.5.

**Loss Matrix**: used to weight the outcome classes differently:
e.g., 0,10,1,0.

Other options exist, but are not usually required. For example,
10-fold cross validation, used in deciding how to prune to the best
decision tree, is generally regarded as the right number. Transferring
the commands from the **Script** tab into the R Console does give you
full access to all options.

Decision trees work with both numeric and categoric data.

R's [rpart](https://www.rdocumentation.org/packages/rpart) package is
used to build the traditional decision tree.
