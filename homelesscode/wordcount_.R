setwd("/Users/deborahsiegel/software/spark-1.6.0-bin-hadoop2.4")
Sys.setenv(SPARK_HOME="/Users/deborahsiegel/software/spark-1.6.0-bin-hadoop2.4")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-example")
sqlContext <- sparkRSQL.init(sc)

###########read a text file into an RDD#################
lines_rdd <- SparkR:::textFile(sc, 'README.md')
######################################################

#######number of characters in each line###########
counts <- SparkR:::map(lines_rdd, nchar)
#SparkR:::take(counts, 10)   #returns a list
unlist(SparkR:::take(counts,10))
###################################################

#######words per line################################

#when you collect an rdd it comes back as a list in r. 
unlist(collect(lines_rdd))


#myFunc <- function(x) { paste(x)}
#d <- SparkR:::flatMap(lines_rdd, myFunc)   #head(d) object of type 'S4' is not subsettable
#collect(d) #returns a list.. need to convert to df
#e <- createDataFrame(sqlContext, d)
#collect(e)
#or more efficiently
#g <- createDataFrame(sqlContext,SparkR:::flatMap(lines_rdd, myFunc))
#collect(g)

###############words per line##################
#this doesnt work -- it returns nulls
#totals <- SparkR:::lapply(lines_rdd, function(lines) { for (i in 1:length(lines)){ unlist(strsplit(lines[i], "/s")) } })

#no method for coercing this S4 class to a vector
wordsPerLine <- lapply(lines_rdd, function(line) { length(unlist(strsplit(line, " "))) })#nope. 

#this works
words_per_line <- SparkR:::lapply( lines_rdd, function(line) { length(strsplit(unlist(line), " ")[[1]])})
unlist(collect(words_per_line))
###############################################


##############word count###################

#first create the list of all words from the lines
words <- SparkR:::flatMap(lines_rdd,   function(line) {strsplit(line, " ")[[1]]}  )
count(words)
collect(words)

#now create the word tuples
wordCount <- SparkR:::lapply(words, function(word){ list(word, 1L) })

#now reduce the tuples
counts <- SparkR:::reduceByKey(wordCount, "+", 2L)
count(counts) #267
collect(counts)


#####    count iris species     #############
diris <- createDataFrame(sqlContext, iris)
species <- SparkR::select(diris, "Species") #a dataframe, not a list

###   or   ##
species <- createDataFrame(sqlContext, data.frame(iris$Species))
###


species <- SparkR:::flatMap(species,function(line) {line})  #a list
collect(species)
speciesTuples <- SparkR:::map(species, function(word){ list(word, 1) }) #lapply works too. returns a list of lists
collect(speciesTuples)
speciesCounts <- SparkR:::reduceByKey(speciesTuples, "+", 1)
unlist(collect(speciesCounts))

