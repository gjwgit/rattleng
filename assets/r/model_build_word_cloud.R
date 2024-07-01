# Rattle Scripts: generate a trimmed wordcloud png
# 
# Time-stamp: <Sunday 2024-06-30 08:47:30 +1000 Graham Williams>
# 
# Copyright (C) 2024, Togaware Pty Ltd
# 
# Licensed under the GNU General Public License, Version 3 (the "License");
# 
# License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
# Authors: Yixiang Yin, Graham Williams

# Load required libraries.

library(tm)
library(wordcloud)
library(magick)

# Load the text data.

text_data <- readLines("FILENAME")

docs <- Corpus(VectorSource(text_data))

# Preprocessing.

if (STEM) {
  docs <- tm_map(docs, stemDocument)
}

if (PUNCTUATION) {
  docs <- tm_map(docs, removePunctuation)
}

# TODO 20240618 gjw REPALCE "english" WITH A OPTION "LANGUAGE" THAT IS
# CHOSEN THROUGH THE GUI.

if (STOPWORD) {
  docs <- tm_map(docs, removeWords, stopwords("LANGUAGE"))
}

# Convert text data to a single character string
#
# text <- paste(text_data, collapse = " ")

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word=names(v), freq=v)

# Set seed for reproducibility.

set.seed(123)

# TODO STEM=T|F
# if STEM: text <- tm_map(text, stemDocument)

# TODO 20240618 gjw MOVE TO GENERATING SVG OR PDF FORMAT.

# TODO 20240618 gjw REPALCE `WORDCLOUDPATH` WITH `TEMPDIR` FOR ALL
# TEMPARARY FILES.

png("WORDCLOUDPATH/tmp.png", width=800, height=600, units="px")

# Generate word cloud.

wordcloud(words        = d$word,
          freq         = d$freq,
          scale        = c(5,0.5),
          min.freq     = MINFREQ,
          max.word     = MAXWORD,
          random.order = RANDOMORDER,
          colors       = brewer.pal(8, "Dark2"))

dev.off()

# Trim the white space using magick.

image <- image_read("WORDCLOUDPATH/tmp.png")
trimmed_image <- image_trim(image)
image_write(trimmed_image, path = "WORDCLOUDPATH/wordcloud.png")

# Show the top words

d %>% filter(freq >= MINFREQ) %>% print(row.names=FALSE)
