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
directly available in Rattle. We note though that there is always
discussion about whether imputation is a good idea or not. After all,
we end up inventing data to suit the needs of the tool we are
using. We won't discuss the pros and cons here except for general
observations while concentrating on how we might impute values. Do be
aware that imputation is problematic.

Any patterns we notice for missing values can be useful in suggesting
which variables could be candidates for imputing. Refer to the Missing
feature of the Explore tab for details.

When Rattle performs an imputation it will store the results in a
variable of the dataset which has the same name as the variable that
is imputed, but prefixed with IMP_. Such variables, whether they are
imputed by Rattle or already exist in the dataset loaded into Rattle
(e.g., a dataset from SAS), will be treated as input variables, and
the original variable marked to be ignored.

The **Zero/Missing** function ([Survival
Guide](https://survivor.togaware.com/datascience/impute-zeromissing.html))
is the simplest of imputations. It involves replacing all missing
values for a variable with a single value! This makes most sense when
we know that the missing values actually indicate that the value is 0
rather than unknown. For example, in a taxation context, if a tax
payer does not provide a value for a specific type of deduction, then
we might assume that they intend it to be zero. Similarly, if the
number of children in a family is not recorded, it could be a
reasonable assumption to assume it is zero.

For categoric data the simplest approach to imputation is to replace
missing values with a special value, Missing.

The **Mean**, **Median**, and **Mode** functions ([Survival
Guide](https://survivor.togaware.com/datascience/impute-meanmediamode.html))
provide simple, if not always satisfactory, choices for missing values
that are known not to be zero. Using the mean, median, or mode, often
has only limited impact on the distribution, which is good. We might
choose to use the mean, for example, if the variable is otherwise
generally normally distributed (and in particular does not have any
skewness). If the data does exhibit some skewness though (e.g., there
are a small number of very large values) then the median might be a
better choice. The mode can also be used for numeric variables when a
single value is extremely dominant.

For categoric variables, there is, of course, no mean nor median, and
so in such cases we might choose to use the mode (the most frequent
value) as the default to fill in for the otherwise missing values. The
mode can also be used for numeric variables.

Whilst this is a simple and computationally quick approach, it is a
very blunt approach to imputation and can lead to poor performance
from the resulting models.

The **Constant** function ([Survival
Guide](https://survivor.togaware.com/datascience/impute-constant.html))
provides a default value to fill in the gaps. This might be an integer
or real number for numeric variables, or else a special marker or the
choice of something other than the majority category for Categoric
variables.

>
