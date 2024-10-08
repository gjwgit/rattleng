# Welcome to **Rattle** (https://rattle.togaware.com).

Rattle is a toolbox for data science, statistical analyses, data
visualisation, machine learning, and artificial intelligence,
supporting Data Scientists turning their data into stories for genuine
impact. It is used extensively for teaching and by practitioners world
wide. After 20 years Version 6 brings a fresh interface to the
traditional application.

The [Data Science Desktop Survival
Guide](https://survivor.togaware.com/datascience) provides an
introduction to data science and a guide to using Rattle. It is freely
available from [Togaware](https://togaware.com).

Rattle V6 (RattleNG) is implemented using
[Flutter](https://flutter.dev) for the front-end, retaining
[R](https://r-project.org) for the back-end while updating many of the
original Rattle scripts. You are invited to report any issues you
notice on [github](https://github.com/gjwgit/rattleng) where code
contributions are also most welcome.

---

**Getting Started**

Tap the **Dataset** button to choose a data source.  The **Demo**
dataset consists of one year of observations from a weather station in
Canberra.

Alternatively, load your own data, including **csv** (comma separated
value) and **txt** (plain text) files. Support for **xlsx**, **arff**,
**rData**, **odbc**, **corpus**, and R package datasets is planned.

After loading a dataset you can navigate to the **Roles**
feature. Each variable has a role, with most as **Input** (or
independent) variables by default. These are commonly used to predict
a **Target** (dependent) variable. A variable with a unique value for
each observation is automatically identified as **Ident**
(identifier). Idents are ignored when modelling as are those with the
role **Ignore**.

---


**Work Flow**

Rattle encourages a typical data scientist work flow through the left
hand *tabs*. On choosing tab a collection of *features* will be
available through the horizontal tabs. After you *configure* a feature
the *build* button will configure and run an **R template
script**. The results are *display*ed as pages that you can navigate.

At any time visit the **Script** tab to see the **R** code that is
automatically generated. You can export the script as a standalone R
program.

---

**Options**

The toggles within the top left of the configuration panel support
cleansing, unifying, and partitioning. A dataset is cleansed by
removing columns that have a single constant value, and by converting
character columns with only a limited number of values into factors. A
dataset is unified by converting column names to a [standard
format](https://survivor.togaware.com/datascience/normalise-variable-names.html),
and partitioning will split a dataset into [training, tuning, and
testing](https://survivor.togaware.com/datascience/train-tune-and-test-datasets.html)
datasets.

