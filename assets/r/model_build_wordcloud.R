# Rattle Scripts: Generate a Word Cloud image.
#
# Time-stamp: <Friday 2025-01-17 16:19:26 +1100 Graham Williams>
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

# <TIMESTAMP>

# Load required libraries.

library(dplyr)
library(readr)
library(tm)
library(wordcloud)
library(wordVectors)

# The text data will have been loaded into the `txt` variable. If that
# does not exist then convert ds into txt.

if (! exists('txt')) {
  txt <- readr::format_delim(ds, delim=' ')
}

# Convert the data data to a single character string rather than a
# list of strings, if required.
#
# txt <- paste(txt, collapse = " ")

docs <- Corpus(VectorSource(txt))

# Preprocessing.  Note that the order matters!

if (<PUNCTUATION>) {
  docs <- tm_map(docs, removePunctuation, ucp = TRUE)
}

if (<STOPWORD>) {
  docs <- tm_map(docs, removeWords, stopwords("<LANGUAGE>"))
}

if (<STEM>) {
  docs <- tm_map(docs, stemDocument)
}

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word=names(v), freq=v)

# Set seed for reproducibility.

set.seed(123)

# TODO STEM=T|F
# if STEM: text <- tm_map(text, stemDocument)

# TODO 20240618 gjw MOVE TO <GENERATING> SVG OR PDF <FORMAT>.

# TODO 20240618 gjw <REPALCE> `<WORDCLOUDPATH>` WITH `<TEMPDIR>` FOR ALL
# <TEMPARARY> <FILES>.

svg("<TEMPDIR>/wordcloud.svg")

# Generate word cloud.

wordcloud(words        = d$word,
          freq         = d$freq,
          scale        = c(5,0.5),
          min.freq     = <MINFREQ>,
          max.word     = <MAXWORD>,
          random.order = <RANDOMORDER>,
          colors       = brewer.pal(8, "Dark2"))

dev.off()

# Trim the white space using magick.

# image <- image_read("<TEMPDIR>/tmp_wordcloud.png")
# trimmed_image <- image_trim(image)
# image_write(trimmed_image, path = "<TEMPDIR>/wordcloud.png")

# Show the top words

d %>% filter(freq >= <MINFREQ>) %>%  dplyr::slice_head(n = <MAXWORD>) %>%  print(row.names = FALSE)

# --- Train Word Vectors ---
# This section trains a Word2Vec model using the 'txt' variable.

cat("> WordVectors: Preparing text data for training...\n")

# Define temporary file paths.

temp_dir         <- "<TEMPDIR>" # Ensure <TEMPDIR> is replaced with the actual temp directory path.
text_file_path   <- file.path(temp_dir, "w2v_input_for_training.txt")
model_output_path <- file.path(temp_dir, "w2v_model_trained.bin") # Output as binary.

# Parameters for training (adjust as needed).

vector_size      <- 100
window_size      <- 5
min_count        <- 5 # Minimum word frequency

trained_model <- tryCatch({
    # Write the 'txt' variable content to the temporary file.
    # Assuming 'txt' is a character vector where each element is a document/line.

    writeLines(as.character(txt), text_file_path)
    cat("> WordVectors: Starting model training...\n")

    # Train the model.

    train_word2vec(train_file = text_file_path,
                   output_file = model_output_path,
                   vectors = vector_size,
                   window = window_size,
                   min_count = min_count,
                   threads = 1) # Use 1 thread generally

    cat(sprintf("> WordVectors: Model training complete. Model saved to %s\n", model_output_path))

}, error = function(e) {
    cat(sprintf("> WordVectors Error: Failed during training - %s\n", e$message))
    NULL
})

# Optional: Clean up the temporary input file
# if (file.exists(text_file_path)) file.remove(text_file_path)

# --- Term Occurrence/Frequency ---
# The 'd' data frame contains word frequencies (occurrences).
# Print the top terms based on frequency settings.

cat("> Top Term Frequencies:\n")
d %>%
  filter(freq >= <MINFREQ>) %>%
  dplyr::slice_head(n = <MAXWORD>) %>%
  print(row.names = FALSE)
cat("\n") # Add a newline for separation

# --- Term Associations ---
# Find terms associated with a specific target term.

cat("> Term Associations:\n")

# Placeholder for the term you want associations for
target_term <- "Yes"
# Placeholder for the minimum correlation limit
cor_limit   <- 0.01 # e.g., 0.01

# Check if dtm exists and has terms.

if (exists("dtm") && length(dimnames(dtm)$Terms) > 0) {
  # Find associations using the TermDocumentMatrix
  associations <- tryCatch({
      findAssocs(dtm, terms = target_term, corlimit = cor_limit)
  }, error = function(e) {
      # Handle case where term might not be found or other errors
      cat(sprintf("  - Error finding associations for '%s': %s\n", target_term, e$message))
      list() # Return an empty list on error
  })

  # Print the associations if found
  if (length(associations) > 0 && length(associations[[1]]) > 0) {
      cat(sprintf("  - Associations for '%s' (cor >= %.2f):\n", target_term, cor_limit))
      # Use capture.output to format the list nicely
      formatted_output <- capture.output(print(associations))
      cat(paste("    ", formatted_output, collapse = "\n"), "\n")
  } else if (!inherits(associations, "error")) {
      cat(sprintf("  - No terms found associated with '%s' (correlation >= %.2f)\n", target_term, cor_limit))
  }

} else {
  cat("  - TermDocumentMatrix 'dtm' not available or empty for association analysis.\n")
}
cat("\n") # Add a newline
