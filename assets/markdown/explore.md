# Exploring Data

The first task for a data scientist, on loading their dataset into
Rattle, is to understand what the data looks like and how it is
distributed. I call this *living and breathing your data*.

Back on the **Dataset** tab we saw an initial glimpse of the dataset
&mdash; the first few values from the dataset were listed there.

Here in the **Explore** tab we can further review, for example, how
the values of each of variables in the dataset are distributed &ndash;
explore the **distributions**. This provides much more insight into
the data leading to a better understanding of the data and leading ask
questions of the data. Like why does the data look like it does? Are
there any obvious or even subtle oddities about the data?

The **Summary** feature summarises the data values for all non-ignored
variables from the dataset. For factors we see the number of levels
the variable has, the data type, and the number of missing values in
that variable, and so on.  The various pages of this Summary delve
into the factors and their levels, summaries of the distribution of
each variable, and some of the typical measures that we use to gain
insight. You will also see, for example, measures called
[Kurtosis](https://en.wikipedia.org/wiki/Kurtosis) and
[Skewness](https://en.wikipedia.org/wiki/Skewness) for numeric
variables that allow us to measure the spread of the data. We can
compare this across the available numeric variables.

The **Visual** features presents the data distribution as plots or
charts. The various plots include box plots, density plots, cumulative
plots and a Benford's plot for numeric data. For categoric data we
will be presented with a bar chart, a dot plot, and a mosaic plot.

Understanding missing data can be important in understand some
limitations of the dataset. The **Missing** feature presents several
textual and graphical views of the missing data and patterns of
missing data.

Exploring **Correlations** between variables in the dataset can
deliver further insight into the dataset.

Statistical **Tests** provide robust observations of the data.

>
