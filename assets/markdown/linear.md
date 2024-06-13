**Linear and Generalised Linear Models**

A linear regression model is the traditional method for fitting a
statistical model to data. It is appropriate when the target variable
is numeric and continuous.

The family of generalized linear models extends traditional linear
regression to targets with non-normal (non-gaussian)
distributions. Linear regression models are iteratively fit to the
data after transforming the target variable to a continuous numeric.

Generalized linear regression, applied to a dataset with a numeric,
continuous target variable, will build the same model, using a
different algorithm.

The generalised algorithm is parameterised by the distribution of the
target variable and a link function relating the mean of the target to
the inputs. These two parameters describe what we often refer to as a
family, such as Poisson, Logistic, etc.

If the target has just two possible outcomes it is transformed using a
logistic or probit function.  A probit regression gives similar
results to the logistic regression, but often with smaller
coefficients.
