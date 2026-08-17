<!-- markdownlint-disable MD041 -->

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)

[![GitHub License](https://img.shields.io/github/license/gjwgit/rattle)](https://raw.githubusercontent.com/gjwgit/rattle/main/LICENSE)
[![GitHub Version](https://img.shields.io/badge/dynamic/yaml?url=https://raw.githubusercontent.com/gjwgit/rattle/master/pubspec.yaml&query=$.version&label=version&logo=github)](https://github.com/gjwgit/rattle/blob/dev/CHANGELOG.md)
[![GitHub Last Updated](https://img.shields.io/github/last-commit/gjwgit/rattle?label=last%20updated)](https://github.com/gjwgit/rattle/commits/dev/)
[![GitHub Commit Activity (dev)](https://img.shields.io/github/commit-activity/w/gjwgit/rattle/dev)](https://github.com/gjwgit/rattle/commits/dev/)
[![GitHub Issues](https://img.shields.io/github/issues/gjwgit/rattle)](https://github.com/gjwgit/rattle/issues)

Download the latest version:
**GNU/Linux**
[zip](https://access.togaware.com/rattle-linux.zip) or
[deb](https://access.togaware.com/rattle_amd64.deb);
**macOS**
[zip](https://access.togaware.com/rattle-macos.zip);
**Windows**
[inno](https://access.togaware.com/rattle-windows-inno.exe).

Visit [togaware](https://rattle.togaware.com) for details and
[reddit](https://www.reddit.com/r/SAI_Rattle/) for community
discussion.

# Rattle the Next Generation Data Scientist

[Rattle](https://rattle.togaware.com) has been in development and use
for almost 20 years as a Data Mining and now Data Science toolkit for
the apprentice and practising Data Scientist. The open source software
and it books and papers have been used by educators, consultants, and
practitioners across industry and government, to turn data into
knowledge, through machine learning and artificial intelligence.

But now, it is time for a refresh. To install the new Rattle visit the
[Installers](https://github.com/gjwgit/rattle/tree/dev/installers/README.md).

Rattle, available from [github](https://github.com/gjwgit/rattle),
remains sympathetic to the original Rattle user interface,
functionality, and goals, as presented in the
[Rattle](https://bit.ly/rattle_data_mining) book. However, it brings
to the community a modern user interface refresh implemented in
**Flutter**. The underlying **R** foundations remain firmly in place
and encapsulated within a more readily extensible framework. A new
edition of the Rattle book will soon be available.

Over the past 15 years we have also matured in how we deliver data
science and analytics. Rattle delivers a new perspective on
scripting data science in R through templates as introduced in my more
recent book, [The Essentials of Data
Science](https://bit.ly/essentials_data_science). The concept of
templates for data science now provides the foundations for a flexible
and extensible application in Rattle.

You can also review my [Desktop Data Mining Survival
Guide](https://datamining.togaware.com) published online by Togaware.

[//]: # (The detailed coding documentation for our new Flutter/Dart based)
[//]: # (Rattle is available online from the [Solid Community)
[//]: # (AU]&#40;https://solidcommunity.au/docs/rattle/&#41;.)

The Rattle rewrite is being lead by Professor Graham Williams (the
original Rattle author), Chief Scientist of the Software Innovation
Institute of the Australian National University.  Significant
contributions have also been made by Yixiang Yin.

## Quick Start and Current Status

You will need to install R, separate to the app itself. Visit the [R
Project](https://www.r-project.org/) for details.

Then install Rattle for your operating system as detailed in the
installers
[README](https://github.com/gjwgit/rattle/blob/dev/installers/README.md).

Then:

+ Start Rattle.
+ From the **Dataset** tap the **Dataset** button and then choose
  **Weather** to load the Canberra weather dataset for 1 year. You can
  also load your own CSV or TXT file by tapping the **Filename**
  button instead. Other demo datasets are also available.
+ Tap the right pointing arrow to view the **Roles** page where you
  can specify the role for each variable. Defaults will have been set.
+ Notice the toggle buttons to the top right of the **Dataset** page:
  **Cleanse**, **Unify** and **Partition**. Hover the mouse to
  view the tooltips.
+ Review and understand the dataset from the **Explore** tab. Here you
  will see statistical summaries, visualisations of the data
  distributions, explore the missing data, check for correlations and
  undertake some statistical tests.
+ The data can then be tidied up through the **Transform**
  tab. Missing values can be imputed or removed, distributions can be
  re-scaled, variable values can be re-coded, and general cleanup of the
  data is supported.
+ To build an AI model, tap the **Model** tab and then the **Tree**
  feature and then the **Build** button. A tree model is built and you
  can view the decision tree both textually and graphically by
  scrolling through the pages. A rich selection of AI algorithms is
  available.
+ Having built a model, typically a predictive model, the
  **Evaluation** tab allows you to assess how good the model is.
+ Tap the **Console** tab to see the R code being run within an R
  session. You can even type R commands there to have them run.
+ Tap the **Script** tab and scroll the window to view the latest R
  commands run. Then tap the **Export** button to save the full script
  to `script.R` (no options currently to change the name or location
  of the saved script file).
+ From your own command line run `Rscript script.R`

A dataset can also be named on the command line, so that it is loaded on
startup rather than through the **Dataset** button:

```bash
rattle myData.csv
```

The filename can be relative to the current directory and can be a
**csv**, **xlsx**, or **txt** file. Rattle starts on the **Roles** page
of the **Dataset** tab, ready to review the variable roles.

On macOS, where the app is a bundle, either run the binary within the
bundle or use `open`, noting that `open` does not pass on the current
directory and so the filename needs its full path:

```bash
/Applications/rattle.app/Contents/MacOS/rattle myData.csv
open -a rattle --args ~/myData.csv
```

When developing from source, pass the filename through to the app with
`flutter run --dart-entrypoint-args myData.csv`.

Rattle reports its version, or what it accepts on the command line, and
exits without starting up:

```bash
$ rattle --version
rattle 6.5.52

$ rattle --help
Usage: rattle [OPTIONS] [FILE]

Rattle: Data Science with R.

Options:
  -h, --help     Report this message and exit.
  -v, --version  Report the version and exit.

FILE is a csv, xlsx, or txt dataset to load on startup, rather
than loading it through the DATASET button.

Visit https://rattle.togaware.com for details.
```

Currently implemented features include:

+ Dataset
  + Demo
    + Weather (and 2007 dataset)
    + Audit
    + Protein
    + Movies
    + Sherlock
    + US Population
  + CSV
  + TXT
  + Roles
    + Input/Target/Risk/Ident/Ignore
+ Explore
  + Summary
  + Visual
  + Missing
  + Correlation
  + Tests
+ Transform
  + Impute
  + Rescale
  + Recode
  + Cleanup
+ Model
  + Cluster
  + Association
  + Tree
  + Forest
  + Boost
  + SVM
  + Linear
  + Neural
  + Word Cloud
+ Evaluate
  + Error Matrix
  + ROC Chart
+ Console
  + The live R session
+ Script
  + Export R code ready to run

## Building Rattle from Source

If you would like to build Rattle from source you certainly can do
so. It is all open source and we do welcome contributions.

First, ensure you have R installed, as described in the installer
[README](https://github.com/gjwgit/rattle/blob/dev/installers/README.md).

Then install Flutter as describe in the [Flutter Install
Guide](https://docs.flutter.dev/get-started/install). In short, to
install on Windows, download the flutter sdk, unzip it to your home
folder, add `C:\Users\<user>\flutter\bin` to the PATH environment
variable, and in a CMD console run `flutter help`.

Then clone the [rattle](https://github.com/gjwgit/rattle)
repository:

```bash
git clone https://github.com/gjwgit/rattle
cd rattle
flutter run
```

Choose your target platform when prompted.

After firing up the rattle app, check in the **Console** tab to make
sure R is running. You should see some R code and the console is
waiting at the R prompt:

```r
...
>
```

Rattle will itself check for these and prompt if they are not
available.

### Latest Code

Rattle continues active development. To get the current app you can
install flutter on your local computer, then clone the github
repository, to your local disk, and from a command line change to the
directory where you cloned the rattle repository (it should contain a
`lib` sub-directory) and type the following command, changing `<os>`
to be one of `windows`, `macos`, or `linux`.

```bash
flutter run -d <os>
```

## How you can Help

Rattle will remain an open source application, free for anyone to
use in any way they like. Contributions are welcome and the simplest
is to make them through pull requests on github. You can fork my
repository, make your changes, and push them back as a pull request to
my repository where I can review and merge into the main product.

There is plenty to do, and if you have a favourite feature of Rattle,
consider either implementing the GUI in Flutter for that component, or
else write a simple template R script that takes a dataset `ds` and
any other template parameters (as ``<<PARAMETER>>`` in the script) to
then do it's stuff! The `<<PARAMETER>>` strings are filled in by the
Flutter interface. See the growing number of scripts in
`assets/scripts/`

Suggested tasks can be found as github issues.

## Rattle Resources

+ Visit the [reddit](https://www.reddit.com/r/SAI_Rattle/) discussion group.

+ Bob Meunchen's [Review of
  Rattle](https://r4stats.com/articles/software-reviews/rattle/)

## Some Rattle teasers

### Rattle's 5 Clicks to Your First AI Model

The traditional Rattle Welcome screen provides an overview of
Rattle. To build your first model, simply click the **Dataset** button
to choose **Demo**, which will load the `rattle::weather`
dataset. Then click the **Model** tab and the **Tree** feature to then
**Build** your first decision tree (an AI model).

![data_page](assets/screenshots/data_page.png)

Click the **Dataset** button to have options to load the data from a
file, from an R package, or the demo weather dataset.

![data_source](assets/screenshots/data_source.png)

After the data is loaded we are presented with a summary.

![data_summary](assets/screenshots/data_summary.png)

### Exploring Data Visually

All of the popular Rattle visualisations are available, modernised
using `ggplot` and the `tidyverse`.

![explore_plot](assets/screenshots/explore_plot.png)

The traditional missing data plots have been updated:

![explore_missing_vim](assets/screenshots/explore_missing_vim.png)

The correlation plot visually highlights related variables:

![explore_correlation_corrplot](assets/screenshots/explore_correlation_corrplot.png)

### Summarising Through WordClouds

For a text file we can gain an insight into the document through a
word cloud.

![explore_wordcloud](assets/screenshots/explore_wordcloud.png)

### Wrangling the Data

A suite of transformation functions are available in Rattle to map
variables in different ways. Each transformation will create a new
variable from the old variable. Here we see `min_temp` being
transformed using the RECENTER feature and each of the transform
functions available. The new variables are prefixed with an indicator
of the type of transformation performed.

![wrangle_recenter](assets/screenshots/wrangle_recenter.png)

### Building Models

A decision tree model is one of the most widely built AI models.

![model_rpart](assets/screenshots/model_rpart.png)

Visualisations are now built and presented by default, compared to
Rattle of Old.

![model_rpart_plot](assets/screenshots/model_rpart_plot.png)

### The R Console

The R console is where everything in R happens. The user can review
the contents of the console and even run R commands themselves. Click
the **Export** button to have the history of R commands from the
console saved to file. Compare this **Export** to that of the
**Script** page where a documented and formatted script is saved to
file.

![console_page](assets/screenshots/console_page.png)

### Everything Captured as Scripts

And be assured, the most important of functionalities, the **Script**
tab's capturing of your interactions, remains a key feature of
Rattle. All of your interactions with R through Rattle are
captured as a documented and nicely formatted script that you can save
to file and replicate your whole project simply by asking R to run the
script. It is also he starting point for modifying a script to do
precisely what you want, beyond what Rattle supports. No lock-in.

![script_page](assets/screenshots/script_page.png)
