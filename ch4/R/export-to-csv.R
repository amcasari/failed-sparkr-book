library(SparkR)
sc <- sparkR.init(master="local[2]",appName="export-to-csv")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()