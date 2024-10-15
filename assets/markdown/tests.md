# Statistical Tests

Statistics plays a crucial role in providing insights into our
data. The statistical tests supported here allow us to compare the
distributions of values of two variables at a time.

The Statistics chapter of the [Data Science Desktop Survival
Guide](https://survivor.togaware.com/datascience/statistics.html)
provides an overview of the different statistical tests supported by
Rattle.

**Two-sample tests** compare the distribution of the values of two
independent variables to determine whether they come from the
same population and the same statistical properties.

**Paired two-sample tests** assume that we have two samples or
observations, and that we are testing for a change, usually from one
time period to another.

To test the *correlation* between variables we use the **Pearson**
test for the hypothesis that the values from paired samples are
correlated.

Tests that inform on the *distribution of the data* are the
**Kolomogorov-Smirnov** test, a non-parametric test of the hypothesis
that the distributions are different, and the **Wilcoxon Signed Rank**
test, a non-parametric test of the hypothesis that paired samples have
different distributions.

Tests for the *location of the average* include the two-sample
**t-Test**, a parametric test used to compare the means of two
independent groups to see if there is a statistically significant
difference between them, and the non-parametric **Wilcoxon Rank-Sum**
test of the hypothesis that the medians are different.

Tests on *variation in the data* include the **f-Test**, a parametric
test of the hypothesis that the variances are different.
