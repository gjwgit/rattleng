Principal Components Analysis

Principal Components Analysis can provide insights into the importance
of variables in explaining the variation found within a dataset. A
principal component is a numeric linear combination of the values of
other variables in the dataset that captures maximal variation in the data.

Two approaches to deriving principal components are supported. The
singular value decomposition (SVD) of the (centered and possibly
scaled) data matrix is preferred for numeric accuracy. An alternative
approach is to determine the eigenvalues of the covariance matrix.

Two plots will be displayed. The bar chart shows the significance of
each of the derived components, whilst the biplot remaps the data
points from their original coordinates to coordinates of the first two
principal coordinates.
