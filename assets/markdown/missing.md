# Missing Data Analysis

Missing values are important to the data scientist. They can result in
some models builders failing, and others generating erroneous results.
Handling missing data is crucial to ensure quality and reliable
analyses.

The missing data analysis performed here presents both textual and
visual analyses.

## Pattern of Missing Data

For both the **Textual** and **Visual** presentation of the pattern of
missing data (the first pair of pages) each row represents a unique
pattern of missing and observed values in your dataset. A 1 (blue) in
a cell indicates that the corresponding variable is observed (not
missing) in that pattern.  A 0 (red) in a cell indicates that the
corresponding variable is missing in that pattern.

The left-hand column of numbers shows the total number of rows in your
dataset having the corresponding missing pattern.

The right-hand column of numbers is the count of variables with
missing values together.

The final row shows the number of observations of each of the
variables in the dataset having missing values.

## Aggregation of Missing Values

The aggregation analysis (second pair of pages) simply reports on the
proportion of values missing (rather than the count).

For the **Visual** presentation the left-hand plot shows these
proportions for each variable.

The right-hand plot of the **Visual** presentation records combination
of missing values across different variables, again showing the
proportion of missing values in each pattern.

## Missing data can result in

+ Bias and Misguided Conclusions: Missing data can introduce bias,
  leading to incorrect conclusions. If not handled properly, it may
  affect statistical tests and model performance1.

+ Reduced Statistical Power: Missing data reduces the statistical
  power of tests. Incomplete information may lead to underestimation
  or overestimation of effects, affecting the validity of results.

+ Model Performance: Machine learning models trained on incomplete
  data may perform poorly. Proper handling ensures robust and accurate
  predictions.

+ Data Integrity: Addressing missing values ensures the integrity of
  your analyses. Imputation (substituting reasonable guesses) or data
  removal are common strategies2.

+ Remember, understanding the types of missing data (MCAR, MAR, MNAR)
  helps choose appropriate methods for handling them

>
