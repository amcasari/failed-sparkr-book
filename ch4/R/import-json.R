library(SparkR)
sc <- sparkR.init(master="local[2]",appName="import-json")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()