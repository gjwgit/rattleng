# Visual Data Analysis

Visual data analysis presents datasets through visual representations
that include graphs and charts. Typically they provide an
understandong of how the values of a variable are distributed. That
is, the **distribution** of the data. 

By visualising data you can identify patterns in the data that in
themselves can provide insights, and even actionable understandings
from the data.

Through data visualisation you can gain an understanding of trends
over time, outliers or unusual observations, and patterns. All of this
contributes to your understanding of the data and the task at hand.

I like to refer to this as living and breathing your data. It is
essential to understand your data as you begin to analyse and model
it.

A variety of R packages like
[ggplot2](https://www.rdocumentation.org/packages/ggplot2) are
utilised to build a variety of charts, plots, and graphs.

For each visualisation you can choose a variable and review the
distribution of its values. Many different types of charts are
generated for the chosen variable to present the data from different
perspectives. While reviewing a specific chart you can change the
selected variable to review it's distribution.

> 

## Numeric Data

A **Box Plot** (also known as a box-and-whisker plot) provides a
graphical overview of how the values of a numeric variable are
distributed. It is useful for quickly ascertaining the skewness of the
distribution of the data. If we have identified a Target (or a Group
By) variable, then the boxplot will also show the distribution of the
values of the variable partitioned by the values of the target/group
variable. For the **Demo** dataset we can see the variable min_temp
grouped by rain_tomorrow.

The boxplot shows the median (also known as the second quartile or the
50th percentile) is the thicker line within the box. The top and
bottom extents of the box identify the upper quartile (the third
quartile or the 75th percentile) and the lower quartile (the first
quartile and the 25th percentile). The extent of the box is known as
the interquartile range. The vertical lines extend to the maximum and
minimum data points that are no more than 1.5 times the interquartile
range from the median. Outliers (points further than 1.5 times the
interquartile range from the median) are then individually
plotted. The mean is displayed as the asterisk.

The notches in the box, around the median, indicate a level of
confidence about the value of the median for the population in
general. It is useful in comparing the distributions, and allows us to
say whether the distributions being presented have significantly
different medians.


A **Density Plot** provides a quick and useful graphical view of the
spread of the data similar to a histogram but with a smoothed estimate
of the data distribution. The y-axis is a probability density function
giving a view of where the values of the variable are concentrated. So
peaks represent where the data values are concentrated and the number
of peaks indicative of the modality of the distribution. We can also
see the spread of the distribution of the data. By using a **Group
By** option we see the impact of partitioning the data by this other
variable, looking for differences in the central tendency, spread, and
modality between groups. The tails of the density plot provide
information about outliers and skewness. Long tails suggest the
presence of outliers, and the direction of the tail indicates skewness
in the distribution (right-skewed or left-skewed).

An **Empirical Cumulative Distribution Function** plot (or ECDF for
short) provides a graphical representation of the cumulative
distribution of a dataset. It shows how the data values are
distributed across the range of the dataset, highlighting the
proportion of observations below each value. The x-axis represents the
data values from the dataset while the y-axis is the proportion of
data points below a particular value of x. Such plots provide a
different but interesting view of how the data is distributed,
accumulative over the x range. It helps in understanding the spread
and concentration of data points and can be used to compare different
datasets or groups.

A **Benford Plot** uses Benford's Law which has proven to be effective
in identifying oddities in data, for example in fraud
detection. Benford's law relates to the frequency of occurrence of the
first digit in a collection of numbers. In many cases, the digit '1'
appears as the first digit of the numbers in the collection some 30%
of the time, whilst the digit '9' appears as the first digit less than
5% of the time. This rather startling observation is certainly found
empirically to hold in many collections of numbers, such as bank
account balances, taxation refunds, stock prices, death rates, lengths
of rivers. Indeed it is observed for processes described by power laws
which are common in nature. By plotting a collection of numbers
against the expectation as based on Benford's law, we are able to
quickly see any odd behaviour in the data.

Benford's law is not valid for all collections of numbers. For
example, people's ages would not be expected to follow Benford's Law,
nor would telephone numbers. So use the observations with care.

> 

## Categoric Data

A **Bar Chart** provides a simple yet effective visualisation of the
distribution of the values for a categoric variable, allowing us to
compare the frequency of the different categories. The height of each
bar represents the frequency of the value of the corresponding
category.

A **Dot Plot** displays the distribution of data points for small to
moderate-sized datasets. Each dot represents one or more data points.

A dot plot is a straightforward and effective way to visualize the distribution of data points, particularly for small to moderate-sized datasets. Each dot represents one or more observations, and the overall pattern of dots helps to identify the distribution, frequency, and any potential outliers in the data.

￼
￼
￼
￼
￼
...

A **Mosaic Plot** See [togaware](https://datamining.togaware.com/survivor/Mosaic_Plot.html)

A **Pairs Plot** ...

> 
