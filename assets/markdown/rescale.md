# Rescale Variables

Different model builders require different characteristics of the data
from which the models will be built. For example, when building a
clustering using any kind of distance measure, we may need to
normalise the data. Otherwise, a variable like Income will overwhelm a
variable like Age, when calculating distances. A distance of 10
``years'' may be more significant than a distance of $10,000, yet,
$10,000 swamps $10 when they are added together, as would be the case
when calculating distances.

In these situations we will want to Normalise our data. The types of
normalisations (available through the Normalise function of the
Wrangle tab) include re-centering and rescaling our data to be around
zero, rescaling our data to be in the range from 0 to 1 (Scale [0,1]),
covert the numbers into a rank ordering (Rank), and finally, to do a
robust rescaling around zero using the median (-Median/MAD).

The original data is not modified. Instead, a new variable is created
with a prefix added to the variable's name that indicates the kind of
transformation.

The **Rescale** function is a common normalisation is to recenter and
rescale our data. The simplest approach to do this is to subtract the
mean value of a variable from each observation's value of the variable
(to recenter the variable) and to then divide the values by the
root-mean-square of the variable values, which re-scales the variable
back to a range within a few integer values around zero.

Rattle relies on the scale function from the base package to perform
the re-centering:

```r
> ds %<>% mutate(RRC_evaporation = scale(evaporation)[,1]
> summary(ds$RRC_evapration)
```

You will note that the resulting mean is not precisely zero, but
pretty close.

The **Scale [0,1]** function supports another common requirement to
remap our data to the [0,1] range.

The **Rank** function will convert the values of a numeric variable
into a rank.

The **Median/MAD** function is considered to be a robust version of
the standard Recenter option. Instead of using the mean and standard
deviation, we subtract the median and divide by median absolute
deviation.

>
