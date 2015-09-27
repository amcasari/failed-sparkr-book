library(SparkR)
sc <- sparkR.init(master="local[2]",appName="handling-missing-data")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()