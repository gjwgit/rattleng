# Numeric Variable Correlation

A correlation analysis provides insights into the independence of or
the relationship between the numeric variables of the
dataset. Modelling often assumes independence and better models will
result when using independent input variables.

A table of the correlations between each of the numeric variables is
generated together with correlation plots to visually highlight strong
positive and negative correlations. The variables for the table and
the plots are ordered for better presentation.

A hierarchical corrleation plot is also presented as a dendrogram to
provide visual clues to the degree of the relationship between
variables and groups of variables. Depending on the data, you may find
groupings of variables that are highly correlated. These will be
obvious in most cases and you should conider how to handle groups of
correlated variables.

Once you have identified the groups of variables that are correlated,
you may want to reduce the number of variables you are including in your
modelling.
For example, sometimes we choose to remove all
but one of the variables in the group, as a variable selection
operation.
