# our text file to work with
inputFile <- "/Users/amcasari/repos/triumph-book/ch4/data/imsdb-com-scripts-princess-bride/princess-bride.txt"

library(SparkR)
sc <- sparkR.init(master="local[2]",appName="spark-r-word-count")
sqlContext <- sparkRSQL.init(sc)

lines <- SparkR:::textFile(sc, inputFile)
words <- SparkR:::flatMap(lines, function(line) { strsplit(line, " ")[[1]]})
wordCount <- SparkR:::lapply(words, function(word) { list(word, 1L)})
counts <- SparkR:::reduceByKey(wordCount, "+", 2L)
output <- collect(counts)

head(output)

sparkR.stop()