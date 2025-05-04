# Load required libraries
library(tm)
library(magrittr) # For the pipe operator %>%

# Get the path from FILENAME placeholder and extract the basename
corpus_path <- "<FILENAME>"
dsname <- basename(corpus_path)

# Create a proper source for the Corpus from the directory
corpus_source <- tm::DirSource(corpus_path)

# Create the corpus from the source
docs <- tm::Corpus(corpus_source)

# Create document-term matrix
dtm <- tm::DocumentTermMatrix(docs)

# Show a summary of the document-term matrix
print(tm::inspect(dtm))

# Save the corpus and DTM for later use
assign("corpus", docs, envir = .GlobalEnv)
assign("dtm", dtm, envir = .GlobalEnv)

cat("Corpus loaded successfully from directory:", corpus_path, "\n")
cat("Document-term matrix created with dimensions:", dim(dtm)[1], "documents x", dim(dtm)[2], "terms\n")
