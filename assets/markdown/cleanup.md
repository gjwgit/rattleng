# Cleanup the Dataset

It is quite easy to get the dataset variable count up to significant
numbers through the use of the **Transform** tab features **Impute**,
**Rescale**, and **Recode**. The **Cleanup** option supports the
deletion of rows (observations) and columns (variables) from the
dataset. You can freely undertake transforms that add new variables,
explore whether they play a role in the analysis, and to remove any
that are not required.

To undertake your dataset **Cleanup** you can choose from the
following options:

+ **Delete Vars with Missing**;

+ [Delete Obs with Missing](https://survivor.togaware.com/datascience/drop-obs-with-missing-values.html);

+ [Delete Ignored](https://survivor.togaware.com/datascience/drop-columns.html);

+ **Delete Variable**.

If you view the dataset summary page (the second page of each of the
features of the Cleanup tab) you will see the updated summary after
each of the updates.

The dataset summary page will eventually also provide an option to
**Save** your dataset back to a **csv** file. In the meantime, after
you have updated your dataset in various ways you can export it back
to a **csv** file from the **Console** tab with a command like:

```r
ds %>%
  dplyr::select(date, location, min_temp, max_temp, temp_9am, temp_3pm) %>%
  readr::write_csv('my_new_dataset.csv')
```

>
