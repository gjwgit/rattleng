# Rescale Variables

Different model builders require different characteristics of the data
from which the models will be built. For example, when building a
clustering using any kind of distance measure, we may need to
normalise the data. Otherwise, a variable like Income will overwhelm a
variable like Age, when calculating distances. A distance of 10 years
in age may be more significant than a distance of 10,000 dollars in
income, yet, 10,000 swamps 10 when they are added together, as would
be the case when calculating distances.

In these situations we will want to Normalise the data. The types of
normalisations (available through the Normalise function of the
Wrangle tab) include re-centering and rescaling the data to be around
zero, rescaling the data to be in the range from 0 to 1 (Scale [0,1]),
covert the numbers into a rank ordering (Rank), and finally, to do a
robust rescaling around zero using the median (-Median/MAD).

The original data is not modified. Instead, a new variable is created
with a prefix added to the variable's name that indicates the kind of
transformation.

+ [Recenter](https://survivor.togaware.com/datascience/rescale-data-using-recenter-in-rattle.html)
  is a common normalisation which subtracts the mean from each
  observation and divides each observation by the root-mean-square,
  resulting in values centered around 0 and spreading across the
  negative to positive values, using
  [base::scale](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/scale).

+ **Scale [0,1]** function supports another common requirement to
  remap the data to the [0,1] range.

+ [Rank](https://survivor.togaware.com/datascience/rescale-data-using-rank.html)
  will convert the values of a numeric variable into a rank using
  [base::rank()](https://www.rdocumentation.org/packages/base/topics/rank).

+ **Median/MAD** function is considered to be a robust version of the
  standard Recenter option. Instead of using the mean and standard
  deviation, we subtract the median and divide by median absolute
  deviation.

See the [Data Science Survival
Guide](https://survivor.togaware.com/datascience/rescale-data-in-rattle.html)
for more details.

>
