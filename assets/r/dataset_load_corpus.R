# Load a corpus into the session for text mining.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2025-05-13 07:28:54 +1000 Graham Williams>
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

dsname <- "<FILENAME>" %>% basename()

# Get the path from FILENAME placeholder and extract the basename.

corpus_path <- "<FILENAME>"

# Create a source for the Corpus from the directory, loading only text
# files.

corpus_source <- tm::DirSource(directory = corpus_path,
                               encoding  = "UTF-8",
                               pattern   = ".*\\.txt$")

# Create the corpus from the source.

docs <- tm::Corpus(corpus_source)

# Keep a copy of the original docs so we can selectively cleanse.

odocs <- docs

# Create document-term matrix.
## We do this here for the dataset display page. Eventually we might
## want to generate a nicer summary and then leave the dtm to
## model_build_text_mine.R

dtm <- tm::DocumentTermMatrix(docs)

# DATASET DISPLAY: Show a summary of the document-term matrix.

docs
tm::inspect(dtm)
for (i in 1:length(docs)) { cat(rownames(dtm)[i], " "); print(docs[[i]]); cat("\n") }
