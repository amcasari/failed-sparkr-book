library(SparkR)
sc <- sparkR.init(master="local[2]",appName="import-json")
sqlContext <- sparkRSQL.init(sc)

# JSON dataset pointed to by a path, either a file or a directory
inputPath <- "/Users/amcasari/repos/triumph-book/ch4/data/sample-json.json"

df <- jsonFile(sqlContext, inputPath)

head(df)

sparkR.stop()