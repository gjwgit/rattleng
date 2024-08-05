Welcome to **RattleNG** the *Next Generation of Rattle*
(https://rattle.togaware.com).

RattleNG (also known as Rattle Version 6) is the working name for a
new generation toolbox for data science, statistical analyses, data
visualisation 📊, machine learning, and artificial intelligence.
Rattle supports the Data Scientist in turning their data into stories
that will have genuine business impact.  This is a new version of the
20 year old Rattle, used extensively in teaching and in industry world
wide.

Visit the [Data Science Desktop Survival
Guide](https://survivor.togaware.com/datascience) for a comprehensive
overview of Data Science. The book includes extensive guides to using
Rattle.

This new Rattle is implemented using [Flutter](https://flutter.dev)
for the front-end whilst the back-end remains
[R](https://r-project.org), utilising many of the original Rattle
scripts. The scripts are being modernised to take advantage of the
latest developments in R. Please bear with us as we modernise Rattle.
Please be welcome to report any issues you notice to
[github](https://github.com/gjwgit/rattleng).  Contributions of code
are also most welcome.

> 

## Getting Started

To get started, press the **Dataset** button to choose a data source,
and for a quick start press **Demo**. This loads a dataset consisting
of one year of observations from a weather station in Canberra that
can be used to explore Rattle's functionality.

You can also load a **csv** file (for structured data analysis,
including data mining) or a **txt** file (for unstructured data
analysis including text mining). The data contained in the file
becomes your dataset used throughout Rattle.

At any time, be sure to visit the **Script** tab to see the **R** code
that is automatically generated for you from all of your activity. You
can export the script, as `script.R` as a standalone R program. Visit
the Script tab for details.

> 

## Resources

The original Rattle is well covered in the book **Data Mining with
Rattle and R** (https://bit.ly/rattle_data_mining). The concept of R
templates for data science, upon which the R back-end is based, was
introduced in **The Essentials of Data Science**
(https://bit.ly/essentials_data_science). Both books are available
from Amazon. The [Desktop Data Science Survival
Guide](https://survivor.togaware.com/datascience) includes Rattle
documentation and is freely available from
[Togaware](https://togaware.com).

Rattle is licensed 🪪 under the [GNU General Public License, Version
3](https://www.gnu.org/licenses/gpl-3.0.en.html), making it free for
you to use for ever. Rattle comes with ABSOLUTELY NO WARRANTY.

Rattle, RattleNG, and the collection of R template scripts are
Copyright © 2006-2024 Togaware Pty Ltd. Rattle is a registered
trademark of Togaware Pty Ltd. Rattle was created and implemented by
Graham Williams with many contributions as acknowledged in the About
menu. Donations to support the ongoing development can be made through
[Togaware](https://togaware.com/onepager.html).

> 

## Dataset Variable Roles

The major data analytics in Rattle is implemented through **R template
scripts**. The templates are run after their configurations are tuned
through the user interface. The updated template is then sent to **R**
to undertake the analysis. The results are presented through the
Rattle interface.

Each variable in a dataset is identified with a **Role**. Most
variables will be identified as **Input** (or independent) variables,
used as the inputs to a model used to predict a **Target** (dependent)
variable. The Input variables are also those that can be selected for
visualising, etc.

Variables can also be identified as a so-called **Risk** variable (a
variable which is not used for modelling as such) or as **Ignore**
which are ignored completely for our purposes. The default role for
most variables is that of an Input (i.e., independent)
variable. Generally, these are the variables that will be used to
predict the value of a Target (or dependent) variable.

Any variable that has a unique value for each observation is
automatically identified as an **Ident** (identifier). Any number of
variables can be tagged as being an Ident. All Ident variables are
ignored when modelling.

Rattle uses simple heuristics to guess at the roles of variables. Most
are Input, one is identified as a Target, often the last variable or
another which is categoric with only a few distinct values.

> 
