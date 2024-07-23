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
[object.size()](https://www.rdocumentation.org/packages/utils/topics/object.size)
function to determine the current amount of memory the dataset is
taking up:

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
