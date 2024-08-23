# Recode Variable Values

**Recode** supports re-mapping operations, including binning and
mapping categoric variables into indicator variables.

[Binning](https://survivor.togaware.com/datascience/binning.html)
provides Quantile, KMeans, and Equal Width binning, with a default of
4 bins. The generated variables are prefixed with either BQU_, BKM_,
and BEW_ respectively, and n suffix with the number of bins.

[Indicator
Variables](https://survivor.togaware.com/datascience/indicator-variables.html)
support model builders that do not handle categoric variables,
including neural networks and regression. A categoric variable is
transformed into a collection of indicator variables, one for each
value of the categoric variable. These have a value of either 0 or 1
to indicate the actual categoric value. Variables are prefixed by TIN_
followed by the variable name and then the categoric value.

[Join
Categorics](https://survivor.togaware.com/datascience/join-categorics.html)
provides a convenient way to stratify the dataset, based on multiple
categoric variables. It multiplies the categoric values of the two
variables. The resulting
variables are prefixed with TJN_ and include the names of both the
constituent variables.

>
