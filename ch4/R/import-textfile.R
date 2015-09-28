library(SparkR)
sc <- sparkR.init(master="local[2]",appName="import-textfile")
sqlContext <- sparkRSQL.init(sc)

df <- createDataFrame(sqlContext, morley)

sparkR.stop()