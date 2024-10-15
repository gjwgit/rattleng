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
through the Transform tab it is a good idea to save the data. We can
do this from the **Console** tab:

```r
ds %>%
  dplyr::select(date, location, min_temp, max_temp, temp_9am, temp_3pm) %>%
  readr::write_csv('my_new_dataset.csv')
```

Visit the [Data Science Survival
Guide](https://survivor.togaware.com/datascience/transforming-data-in-rattle.html)
for further details.

>
