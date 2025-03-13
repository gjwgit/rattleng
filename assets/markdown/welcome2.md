# Work Flow

Rattle encourages a data science work flow down the left hand vertical
*tabs*. For each tab we expose *features* available through
horizontal tabs. After you *configure* a feature the *build* button
will run an **R template script**. The results are *display*ed as
pages that you can navigate. Be sure to visit the **Script** tab
to see the **R** code that is generated and can be exported as a
standalone R program.

---

## Getting Started

Tap the **Dataset** button of the **Dataset** tab to choose a
data source.  A choice of demo datasets is available. Tooltips explain
each one.

Alternatively, load your own data, including **csv** (comma separated
value), **xlsx** (Excel spreadsheet), and **txt** (plain text)
files. Support for **arff**, **rData**, **odbc**,
**corpus**, and R package datasets is planned.

After loading a dataset you can navigate to the **Roles** page. Each
variable has a role. Most will be **Input** (i.e., independent)
variables by default. These are commonly used to predict a **Target**
(dependent) variable. Variables with a unique value for each
observation are automatically identified as **Ident**
(identifier). Idents are ignored when modelling as are those with the
role **Ignore**.

---

## Options on Loading your Dataset

The toggles at the top right of the Dataset configuration panel
support **Cleanse**, **Unify**, and **Partition** options for your
dataset. Cleansing will remove columns that have a constant value and
will convert character columns with few values into factors. A dataset
is unified by converting column names to a [standard
format](https://survivor.togaware.com/datascience/normalise-variable-names.html),
and partitioning will split a dataset into [training,
tuning/validation, and
testing](https://survivor.togaware.com/datascience/train-tune-and-test-datasets.html)
subsets.

---
