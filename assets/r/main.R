# Rattle Scripts: The main setup.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2024-05-19 14:53:30 +1000 Graham Williams>
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

# Initialise R with required packages.
#
# The concept of templates for data science was introduced in my book,
# The Essentials of Data Science, 2017, CRC Press, referenced
# throughout this script as @williams:2017:essentials
# (https://bit.ly/essentials_data_science). On-line examples are
# available from my Data science Desktop Survival Guide
# https://survivor.togaware.com/datascience/.

# We begin most scripts by loading the required packages.  Here are
# some initial packages to load and others will be identified as we
# proceed through the script. When writing our own scripts we often
# collect together the library commands at the beginning of the script
# here.

# Load required packages from the local library into the R session.

library(rattle)       # Access the weather dataset and utilities.
library(magrittr)     # Utilise %>% and %<>% pipeline operators.
library(janitor)      # Cleanup: clean_names() remove_constant().
library(tidyverse)    # ggplot2, tibble, tidyr, readr, purr, dplyr, stringr

# A pre-defined value for the random seed ensures that results are
# repeatable.

set.seed(42)
