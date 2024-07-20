# Dataset Transformations &mdash; Wrangling Your Data

The **Transform** tab provides a number of features for transforming
or wrangling your dataset. All transformations are accomplished using
R and the actual R code is available in the **Script** tab.

Transformations are not always appropriate. For example, imputation
that is supported under the **Impute** feature can significantly alter
the shape of the distribution of our variables. These operations
require careful consideration.

Different transformations generally apply to either numeric data or to
categoric data. Some transformations can apply to any data type. Generally
**Rescale** and **Impute** mostly apply to numeric data.

In tuning our dataset to suit our needs, we do often transform it in
many different ways. Of course, once we have transformed our dataset,
we will want to save the new version. After working on our dataset
through the Transform tab it is a good idea to save the data through
the Export button. We will be prompted for the name of a CSV file into
which the current transformation of the dataset will be saved.

> 

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
> ds$RRC_evaporation <- scale(ds$evaporation)[,1]
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

# Impute Missing Values

The **Impute** feature supports imputation, which is the process of
filling in the gaps (or missing values) in data. Often, data will
contain missing values, and this can cause a problem for some
modelling algorithms. For example, the random forest option silently
removes any observation with any missing value! For datasets with a
very large number of variables, and a reasonable number of missing
values, this may well result in a small, unrepresentative dataset, or
even no dataset at all!

There are many types of imputations available, only some of which are
directly available in Rattle. We note thought that there is always
discussion about whether imputation is a good idea or not. After all,
we end up inventing data to suit the needs of the tool we are
using. We won't discuss the pros and cons in much detail, but we
provide some observations and concentrate on how we might impute
values. Do be aware though that imputation can be problematic.

If the missing data pattern is monotonic, then imputation can be
simplified. The pattern of missing values is also useful in suggesting
which variables could be candidates for imputing the missing values of
other variables. Refer to the Show Missing check button of the Summary
option of the Explore tab for details

When Rattle performs an imputation it will store the results in a
variable of the dataset which has the same name as the variable that
is imputed, but prefixed with IMP_. Such variables, whether they are
imputed by Rattle or already exist in the dataset loaded into Rattle
(e.g., a dataset from SAS), will be treated as input variables, and
the original variable marked to be ignored.

The **Zero/Missing** function is the simplest of imputations. It
involves replacing all missing values for a variable with a single
value! This makes most sense when we know that the missing values
actually indicate that the value is 0 rather than unknown. For
example, in a taxation context, if a tax payer does not provide a
value for a specific type of deduction, then we might assume that they
intend it to be zero. Similarly, if the number of children in a family
is not recorded, it could be a reasonable assumption to assume it is
zero.

For categoric data the simplest approach to imputation is to replace
missing values with a special value, Missing.

The **Mean**, **Median**, and **Mode** functions provide simple, if
not always satisfactory, choices for missing values that are known not
to be zero. We can use these *central* value of the variable
functions. Using the mean, median, or mode, usually has limited impact
on the distribution. We might choose to use the mean, for example, if
the variable is otherwise generally normally distributed (and in
particular does not have any skewness). If the data does exhibit some
skewness though (e.g., there are a small number of very large values)
then the median might be a better choice.

For categoric variables, there is, of course, no mean nor median, and
so in such cases we might choose to use the mode (the most frequent
value) as the default to fill in for the otherwise missing values. The
mode can also be used for numeric variables.

Whilst this is a simple and computationally quick approach, it is a
very blunt approach to imputation and can lead to poor performance
from the resulting models.

The **Constant** function allows us to provide our own default value
to fill in the gaps. This might be an integer or real number for
numeric variables, or else a special marker or the choice of something
other than the majority category for Categoric variables.

>

# Recode Variable Values

The **Recode** feature provides functionality for re-mapping
operations, including binning, log transforms, ratios, and mapping
categoric variables into indicator variables.

A **Binning** function is provided, choosing between Quantile binning,
KMeans binning, and Equal Width binning. For each option the default
number of bins is 4, and we can change this to suit our needs. The
generated variables are prefixed with either BIN_QUn_, BIN_KMn_, and
BIN_EWn_ respectively, with n replaced with the number of bins. Thus,
we can create multiple binnings for any variable.

An example of why we might want to do this is to visualise data. A
mosaic plot, for exapmle, is only useful for categoric data and so we
could turn Sunshine into a categoric by binning. Also binning can be
used to show a box plot against different targets.

Note that quantile binning is the same as equal count binning.

Rattle can create **Indicator Variables**.  Some model builders do not
handle categoric variables. Neural networks and regression are two
examples. A simple approach in this case is to turn the categoric
variable into some numeric form. If the categoric variable is not an
ordered categoric variable, then the usual approach is to turn the
single variable into a collection of so called indicator
variables. For each value of the categoric variable there will be a
new indicator variable which will have the value 1 for any observation
that has this categoric value, and 0 otherwise. The result is a
collection of numeric variables.

Rattle can transform one or more categoric variables into a collection
of indicator variables. Each is prefixed by INDI_ and the remainder is
made up of the name of the categoric variable (e.g., gender) and the
particular value (e.g., female), to give INDI_gender_female.

There is not always a need to transform a categoric variable. Some
model builders, like the regressions in Rattle, will do it for us
automatically.

The **Join Categorics** option provides a convenient way to stratify the
dataset, based on multiple categoric variables. It is a simple
mechanism that creates a new variable from the combination of all of
the values of the two constituent variables selected in the Rattle
interface. The resulting variables are prefixed with JOIN_ and include
the names of both the constituent variables.

A simple example might be to join gender and marital, to give a new
variable, JOIN_marital_gender.

We might also want to join a numeric variable and a categoric
variable, like the typical age and gender stratification. To do this
we first use the Binning option within Remap to categorise the age
variable

A Log transform is available. The generated variable is prefixed with
REMAP_LOG_.

>

# Cleanup the Dataset

It is quite easy to get our dataset variable count up to significant
numbers. The Cleanup option (not yet available) allows us to tell
Rattle to actually delete columns from the dataset. This allows us to
perform numerous transformations and then to save the dataset back
into a CSV file (by exporting it from the Data tab).

The **Delete Ignored** function will simply remove columns from the
dataset that are marked as Ignore.  As an example, suppose we have
loaded the demonstrator audit dataset. In the **Dataset** tab we might
choose to set the role of Age, Employment, Education, Marital, and
Occupation to be Ignore. In the **Console** tab we can use the
`object.size()` function to determine the current amount of memory the
dataset is taking up:

```r
> object.size(ds)
[1] 128904
```

Now navigate to the **Wrangle** tab and choose the **Cleanup**
feature. Running the **Delete Ignored** function will remove the
columns that we marked as Ignored. Now in the **Console** check how
much space the dataset is taking up:

```r
object.size(ds)
[1] 84216
```

The **Delete Selected** functionality will delete the selected variables.

The **Delete Missing** functionality will delete all variables that
have any missing values. The variables with missing values are
indicated in the data summary.

The **Delete Obs with Missing** functionality, rather than delete
variables with missing values, will delete observations that have any
missing values.

> 
