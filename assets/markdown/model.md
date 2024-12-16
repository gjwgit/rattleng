# Modelling your Data &#8212; Descriptive and Predictive

Descriptive modelling often involves building descriptions of the data
often without having a target variable.  **Cluster** analysis and
**Associations** analysis are often considered as unsupervised
learning, even though both can be considered as presenting predictive
capabilities.

Predictive modelling aims to use data to discover new knowledge that
we can deploy to predict outcomes based on known input
variables. Often the task is to predict something about new
observations based on the historic data that we have loaded into
Rattle. Classification and regression are at the heart of what we
often think of as data mining and predictive modelling, which in a
machine learning context is referred to as supervised learning.

Supervised learning as a traditional data mining approach focuses on
algorithms developed for Artificial Intelligence and Machine Learning
to build classification models. These models are used to classify new
observations into different classes. Rattle supports Decision
**Trees**, Random **Forests**, and **Boost**ing.

Statisticians have traditionally focused on the task of regression
modelling. The aim is to build a mathematical formula that captures
the relationship between a collection of input variables and a numeric
output variable. This formula can then be applied to new observations
to predict a numeric outcome. The and **SVM** (support vector
machine), **Linear** regression, and **Nerual** network models support
regression type models, though the tree-based methods can often also
build regression models.

As well as building a model so that we can apply the model to new data
(the predictions) the structure of the model itself can provide
insights. In particular, we can learn much about relationships between
input variables and the output variable from studying
models. Sometimes these observations themselves deliver benefit from a
data mining project.

After building a model, explore its structure on the pages that are
added to the panel.
