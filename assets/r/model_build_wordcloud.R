# Rattle Scripts: Generate a Word Cloud image.
#
# Time-stamp: <Wednesday 2025-05-07 09:28:40 +1000 Graham Williams>
#
# Copyright (C) 2024-2025, Togaware Pty Ltd
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

# <TIMESTAMP>

# The text data will have been loaded into the `txt` variable. If that
# does not exist, because we have a tabular dataset probably loaded
# for predictive modelling or clusters, then convert `ds` into `txt`.

if (! exists('txt') && ! exists('docs')) {
  txt <- readr::format_delim(ds, delim=' ')
}
##
## Convert the data to a single character string rather than a list of
## strings, if required.
##
## txt <- paste(txt, collapse = " ")

if (exists('txt') && ! exists('docs')) {
  docs <- tm::Corpus(tm::VectorSource(txt))
}

# Preprocessing.  Note that the order matters!

clean_punctuation <- <PUNCTUATION>
clean_stopwords   <- <STOPWORD>
clean_stem        <- <STEM>

if (clean_punctuation) {
  docs %<>% tm::tm_map(tm::removePunctuation,
                       ucp=TRUE,
                       preserve_intra_word_contractions=TRUE,
                       preserve_intra_word_dashes=TRUE)
}

if (clean_stopwords) {
  docs %<>% tm::tm_map(tm::removeWords,
                       tm::stopwords("<LANGUAGE>"))
}

if (clean_stem) {
  docs %<>% tm::tm_map(tm::stemDocument)
}

tdm <- tm::TermDocumentMatrix(docs)
m <- as.matrix(tdm)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word=names(v), freq=v)

# Set seed for reproducibility.  Do we want to have the different
# random results each time, resulting in randomly different models?

randomly <- <RANDOM_PARTITION>

if (! randomly) {
  set.seed(<RANDOM_SEED>)
}
##
## TODO STEM=T|F
## if STEM: text <- tm_map(text, stemDocument)
##
## TODO 20240618 gjw MOVE TO <GENERATING> SVG OR PDF <FORMAT>.
##
## TODO 20240618 gjw <REPALCE> `<WORDCLOUDPATH>` WITH `<TEMPDIR>` FOR ALL
## <TEMPARARY> <FILES>.

svg("<TEMPDIR>/wordcloud.svg")
wordcloud::wordcloud(
  words        = d$word,
  freq         = d$freq,
  scale        = c(5,0.5),
  min.freq     = <MINFREQ>,
  max.word     = <MAXWORD>,
  random.order = <RANDOMORDER>,
  colors       = RColorBrewer::brewer.pal(8, "Dark2")
)
dev.off()
##
## Trim the white space using magick.
##
## image <- image_read("<TEMPDIR>/tmp_wordcloud.png")
## trimmed_image <- image_trim(image)
## image_write(trimmed_image, path = "<TEMPDIR>/wordcloud.png")

# Show the top words

d %>% dplyr::filter(freq >= <MINFREQ>) %>%
  dplyr::slice_head(n = <MAXWORD>) %>%
  print(row.names = FALSE)
