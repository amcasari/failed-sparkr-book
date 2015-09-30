# our text file to work with
inputFile <- "/Users/amcasari/repos/triumph-book/ch4/data/imsdb-com-scripts-princess-bride/princess-bride.txt"

# import the text into an R character object
text <- scan(inputFile, character(0), sep = "\n", quote = NULL)

# load the library for text mining
library(tm)

# create a vector source, which interprets each element of the vector as a document
vs <- VectorSource(text)
show(vs)

# create a corpus from our vector source
corpus <- Corpus(vs)
show(corpus)

# clearly we have some work to do to remove punctution and empty lines
# wonderfully, we can do this using tm_map after we create a corpus
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)

# we need to convert our blob to a sparse matrix to count unique words per line (document)
doc_term_matrix <- DocumentTermMatrix(corpus)

# it will be easier to sum columns as matrix
dtm <- as.matrix(doc_term_matrix)
freq <- colSums(dtm)
freq <- sort(freq, decreasing = TRUE)
head(freq)