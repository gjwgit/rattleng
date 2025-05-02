## "<FILENAME>" need to be changed to integration_test/corpus
dsname <- "<FILENAME>" %>% basename()
## "<FILENAME>" need to be changed to integration_test/corpus
docs <- tm::Corpus("<FILENAME>")
dtm <- DocumentTermMatrix(docs)
inspect(dtm)