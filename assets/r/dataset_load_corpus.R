# Load the corpus from the integration_test/corpus directory.
#
# Copyright (C) 2024-2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Wednesday 2025-03-26 05:49:38 +1100 Graham Williams>
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
# Author: Zheyuan Xu, Graham Williams

# The file `<FILENAME>` is loaded as a CSV file into the template
# variable `ds` (dataset), intialising the `dsname` (a printable name
# for the dataset) and `vnames` (the variable names).
#
# <TIMESTAMP>
#
# The data contained in the file `<FILENAME>`
# is loaded as a CSV file into the template variable `ds` (dataset),
# intialising the `dsname` (a printable name for the dataset) and
# `vnames` (the variable names).
#
# References:
#
# @williams:2017:essentials Chapter 3
#
# https://survivor.togaware.com/datascience/csv-data-reading.html

# Load required packages from the local library into the R session.

library(tm)

# Get the path from FILENAME placeholder and extract the basename.

corpus_path <- "<FILENAME>"
dsname <- basename(corpus_path)

# Create a proper source for the Corpus from the directory.

corpus_source <- tm::DirSource(corpus_path)

# Create the corpus from the source.

docs <- tm::Corpus(corpus_source)

# Create document-term matrix.

dtm <- tm::DocumentTermMatrix(docs)

# Show a summary of the document-term matrix.

tm::inspect(dtm)
