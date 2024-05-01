# Load required library
library(wordcloud)

# Sample text data
text_data <- readLines("FILENAME")

# Convert text data to a single character string
text <- paste(text_data, collapse = " ")


# Set seed for reproducibility
set.seed(123)

# TODO STEM=T|F
# if STEM: text <- tm_map(text, stemDocument)

png("WORDCLOUDPATH", width = 800, height = 600, units = "px")

# Generate word cloud
wordcloud(text, scale=c(5,0.5), min.freq = 1, max.word = MAXWORD, random.order = RANDOMORDER, colors=brewer.pal(8, "Dark2"))

dev.off()