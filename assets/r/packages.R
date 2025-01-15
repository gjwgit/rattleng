# Setup a new Rattle session.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Thursday 2025-01-16 05:18:59 +1100 Graham Williams>
#
# Rattle version VERSION.
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Graham Williams

# Check each of the required pacakges and if not instaleld, then
# install them.

# We want to keep R from asking to select a CRAN site and from asking
# if to create the user's local R library.  Otherwise it fails and the
# user will be awfully confused!

options(repos = c(CRAN = "https://cloud.r-project.org"))
options(install.packages.ask = FALSE)

# Function to install a package without prompting for library
# creation. We then use `library()` each script file to load the
# required packages from the library.

install_if_missing <- function(pkg) {

  # 20241121 gjw When using `requireNamespace(p, character.only=TRUE)`
  # here the `character.only` seemed to be giving an error `unused
  # argument (character.only = TRUE)`. But from command line it did
  # not. Odd. Removed it anyhow.

  if (!requireNamespace(pkg)) {

    # Specify a directory for the library. Tested this on Ubuntu
    # (/home/fred/R/x86_64-pc-linux-gnu-library/4.4), Windows11
    # (C:\\Users\\fred\\AppData\\Local/R/win-library/4.4).

    lib_dir <- Sys.getenv("R_LIBS_USER")

    # Make sure the directory already exists so we won't be prompted
    # to create it.

    if (!dir.exists(lib_dir)) {
      dir.create(lib_dir, recursive=TRUE)
      message("Package Library Created: ", lib_dir)
    }

    # Install the package without prompting for library creation.

    install.packages(pkg, lib=lib_dir, dependencies=TRUE, ask=FALSE)
  }
}

# We install all packages up front so that in all likelihood any large
# install of packages happens just once and on the first startup. This
# will result in the ROLES page being blank while this happens. We
# need to pop up a message to say to check the CONSOLE as Rattle may
# be installing the required packages. For documentation suggest the
# user does the installation of the R package prior to starting
# Rattle.

# 2024-10-07 08:38 gjw This is all getting too hard to check and
# install packages within rattle for now. Instead, emphasise the need
# to install packages before rungging rattle. For Ubuntu we could add
# instructions for updating apt sources or a user installing the
# packages themselves. The latter for now.

pkgs <- c(
  'Ckmeans.1d.dp',
  'Hmisc',
  'NeuralNetTools',
  'VIM',
  'ada',
  'amap',
  'arules',
  'arulesViz',
  'biclust',
  'corrplot',
  'descr',
  'fBasics',
  'ggtext',
  'ggplotify',
  'ggthemes',
  'hmeasure',
  'janitor',
  'lubridate',
  'magrittr',
  'mice',
  'naniar',
  'neuralnet',
  'nnet',
  'partykit',
  'randomForest',
  'rattle',
  'readr',
  'reshape',
  'rpart',
  'skimr',
  'tidyverse',
  'tm',
  'verification',
  'wordcloud',
  'wskm',
  'xgboost')

# Check if the package is installed and if not, install it.

for (p in pkgs) {
  cat('Checking:', p, '\n')
  install_if_missing(p)
}

# As a separate process, load each of the packages from the
# library. 20241121 gjw Using `library(p)` will fail because the
# argument `p` is not evaluated to a string so we wrap it in an
# `eval()`.

for (p in pkgs) {
  eval(parse(text=sprintf('library(%s)', p)))
  # require(p, character.only=TRUE)
}
