# our text file to work with
inputFile <- "/Users/amcasari/repos/triumph-book/ch4/data/uvm-hedonometer/Data_Set_S1.txt"

# first let's check out a few things about our textfile before we import it
library("R.utils", pos = 100)
countLines(inputFile)

# import the text into an R character object
text <- scan(inputFile, character(0), sep = "\n", quote = NULL)

# curious what's in the file?
show(text)

# too much! how about the first five lines?
text[1:5]

# looks like we might be able to create a tab-separated file if:
## 1. we remove the first two lines
new_text <- text[3:length(text)]

## 2. remove some pesky quotes which affect parsing later
library(stringr)
new_text <- str_replace(new_text, pattern = "'", replacement = "_")

# check that we have the rows we want to keep
new_text[1:5]

# save to a new text file for import as a data frame
new_textFile <- "/Users/amcasari/repos/triumph-book/ch4/data/uvm-hedonometer/new-data.txt"
cat(new_text, file= new_textFile , sep = "\n")

# import the tsv into a native dataframe
happy_words_df <- read.table(new_textFile, sep = "\t", header=TRUE)

# check on the lovely new native dataframe
View(happy_words_df)

# now we can convert to a SparkR dataframe for distributed experimentation
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="import-textfile")
sqlContext <- sparkRSQL.init(sc)

df <- createDataFrame(sqlContext, happy_words_df)

# we can see that our schema and data is preserved
head(df)

sparkR.stop()