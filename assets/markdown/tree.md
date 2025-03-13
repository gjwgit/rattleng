# Decision Trees

A **decision tree** is a common data mining tool used widely for its
ease of interpretation. It consists of a root node where the data is
split into two (for a binary tree) smaller datasets using a test on a
single variable. This is then repeated in turn (divide and conquer)
until no further splitting would improve the performance of the model
in predicting the value of the **target** variable

The Gini measure is used in Rattle to select a variable to split the
dataset on. To explore the alternatives, copy the relevant code from
the **Script** tab and paste it into an R Console and change any of
the options. Common options include the minimum split and bucket size,
the maximum depth and complexity of the tree. Rattle also supports
prior probabilities and a loss matrix. See the tool tips for more
information.

Other options exist, but are not usually required. For example,
10-fold cross validation, used in deciding how to prune to the best
decision tree, is generally regarded as the right number. Transferring
the commands from the **Script** tab into the R Console does give
you full access to all options.

Decision trees work with both numeric and categoric data.

R's [rpart](https://www.rdocumentation.org/packages/rpart) package is
used to build the traditional decision tree with parameters controlled
using
[rpart.control](https://www.rdocumentation.org/packages/rpart/topics/rpart.control).
