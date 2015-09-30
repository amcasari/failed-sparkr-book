library(SparkR)
sc <- sparkR.init(master="local[2]",appName="working-in-sql")
sqlContext <- sparkRSQL.init(sc)

inputPath <- "/Users/amcasari/repos/triumph-book/ch4/data/sample-json.json"

buffy <- jsonFile(sqlContext, inputPath)
head(buffy)

registerTempTable(df, "buffy")
slayers <- sql(sqlContext, "SELECT name FROM buffy WHERE role LIKE '%Slayer%'")
head(slayers)

sparkR.stop()

