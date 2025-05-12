# Undertake a text analysis of the corpus provided through `docs`.
#
# Time-stamp: <Monday 2025-05-12 10:28:38 +1000 Graham Williams>
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

# The text data will have been loaded into the `docs` variable, either
# from a single txt file or from a corpus.
#
# If `docs` exists then we will also have had a backup copy in
# `odocs`. This is restored to `docs` so that we can re-run possibly
# changed CLEANSE operations.
#
# If `docs` does not exist then we will have loaded a tabular dataset
# into `ds` so we convert `ds` into `docs`.

if (exists('docs')) {
  docs <- odocs
} else {
  ##
  ## Convert the data to a single character string rather than a list of
  ## strings, if required.
  ##
  ## txt <- paste(txt, collapse = " ")
  txt <- readr::format_delim(ds, delim=' ')
  docs <- tm::Corpus(tm::VectorSource(txt))
  odocs <- docs
}

# Preprocessing.  Note that the order matters to a small
# extent. Probably good to remove stopwords before we do stemming.

clean_punctuation <- <TEXT_PUNCTUATION>
clean_stopwords   <- <TEXT_STOPWORD>
clean_stem        <- <TEXT_STEM>
clean_lower_case  <- <TEXT_LOWER_CASE>
clean_remove_numbers <- <TEXT_REMOVE_NUMBERS>
clean_strip_whitespace <- <TEXT_STRIP_WHITESPACE>
clean_remove_sparse <- <TEXT_REMOVE_SPARSE>
text_sparse_max <- <TEXT_SPARSE_MAX>

if (clean_punctuation) {
  docs %<>% tm::tm_map(tm::removePunctuation,
                       ucp=TRUE,
                       preserve_intra_word_contractions=TRUE,
                       preserve_intra_word_dashes=TRUE)
}

if (clean_lower_case) {
  docs %<>% tm::tm_map(tm::content_transformer(tolower))
}

if (clean_remove_numbers) {
  docs %<>% tm::tm_map(tm::removeNumbers)
}

if (clean_strip_whitespace) {
  docs %<>% tm::tm_map(tm::stripWhitespace)
}

if (clean_stopwords) {
  docs %<>% tm::tm_map(tm::removeWords,
                       tm::stopwords("<LANGUAGE>"))
}

if (clean_stem) {
  docs %<>% tm::tm_map(tm::stemDocument)
}

# Create the term document matrix from the docs.

dtm <- tm::DocumentTermMatrix(docs)

if (clean_remove_sparse) {
  dtm %>% tm::removeSparseTerms(text_sparse_max)
}

m <- as.matrix(dtm)
v <- sort(colSums(m), decreasing=TRUE)
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

# Open an SVG device with specific dimensions to help control
# whitespace.  You can adjust width/height. (zy 20250512)

svg("<TEMPDIR>/wordcloud.svg", width = 4, height = 4)

# Set plot margins to zero (bottom, left, top, right). (zy 20250512)

par(mar = c(0, 0, 0, 0))

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

# Find associations for the specified word in the document-term matrix.

tm::findAssocs(dtm, '<TEXT_COR_WORD>', corlimit=<TEXT_COR_LIMIT>)

# Find word associations and prepare to plot term correlations.

# Display the model visually for review.

svg("<TEMPDIR>/model_wordcloud_cor.svg")
par(mar = c(15, 14, 10, 12))
plot(dtm, terms=tm::findFreqTerms(dtm, lowfreq=<TEXT_COR_FREQ>), corThreshold=<TEXT_COR_LIMIT>)
title("Correlations >= <TEXT_COR_LIMIT> of Frequent >= <TEXT_COR_FREQ> Terms in Document-Term Matrix", line=-1)
dev.off()

# Create a bar chart of the top <MINFREQ> most frequent words.

svg("<TEMPDIR>/word_frequency_barplot.svg", width=10)
d %>%
  dplyr::arrange(desc(freq)) %>%
  dplyr::filter(freq >= <MINFREQ>) %>%
  ggplot2::ggplot(ggplot2::aes(x=reorder(word, freq), y=freq)) +
  ggplot2::geom_bar(stat="identity", width=0.5) +
  ggplot2::coord_flip() +
  ggplot2::labs(
    title = "Terms with Frequency at least <MINFREQ>",
    x = "Term",
    y = "Frequency"
  ) +
  <SETTINGS_GRAPHIC_THEME>() +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(angle = 0, hjust = 0.5),
    plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
  )
dev.off()
