# Load required pacakges into the session library.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-05-07 08:48:05 +1000 Graham Williams>
#
# Rattle version <VERSION>.
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

# <TIMESTAMP>

# We often begin our R scripts by loading the required packages into
# the session from the R library.  Here are the initial packages to
# load. For the purposes of Rattle functions that come from specific
# packages will be explicitly prefixed with the pacakge name, like
# `dplyr::slecect()` to explicitly identify which version of seect is
# being utilised, rather than leaving it to the package load
# order. (gjw 20250507)

# Loading packages requires they are already installed into a local
# library. The RattleNG installation instructions recommends
# installing these packages before running rattle for the first
# time. From within RattleNG, tap the DOWNLOAD button at the top right
# bar of buttons which will run the `packages.R` script to check and
# install any missing packages. (20250507 gjw)

library(ggplot2)      # To support a local rattle theme.
library(ggtext)       # To support markdown text in ggplot titles.
library(glue)         # To glue strings together.
library(rattle)       # Support functions used throughout data science.
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
