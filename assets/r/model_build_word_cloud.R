# Load required library
library(tm)
library(wordcloud)

# Sample text data
text_data <- readLines("FILENAME")

docs <- Corpus(VectorSource(text_data))

# preprocessing
if (STEM) {
    docs <- tm_map(docs, stemDocument)
}
if (PUNCTUATION) {
    docs <- tm_map(docs, removePunctuation)
}
if (STOPWORD) {
    docs <- tm_map(docs, removeWords, stopwords("english"))
}
# Convert text data to a single character string
# text <- paste(text_data, collapse = " ")
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

# Set seed for reproducibility
set.seed(123)

# TODO STEM=T|F
# if STEM: text <- tm_map(text, stemDocument)

png("WORDCLOUDPATH", width = 800, height = 600, units = "px")

# Generate word cloud
wordcloud(words = d$word, freq = d$freq, scale=c(5,0.5), min.freq = MINFREQ, max.word = MAXWORD, random.order = RANDOMORDER, colors=brewer.pal(8, "Dark2"))

dev.off()
