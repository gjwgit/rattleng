# Rattle Scripts: The main setup.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2023-08-23 05:51:51 +1000 Graham Williams>
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

# The concept of the templates was introduced in my book, Graham
# Williams, The Essentials of Data Science, 2017, CRC Press,
# referenced below as @williams:2017:essentials
# (https://bit.ly/essentials_data_science). Also see
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(rattle)       # Access the weather dataset and utilities.
library(magrittr)     # Utilise %>% and %<>% pipeline operators.
library(janitor)      # Cleanup: clean_names() remove_constant().
library(tidyverse)    # ggplot2, tibble, tidyr, readr, purr, dplyr, stringr
