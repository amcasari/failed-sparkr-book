library(SparkR)
sc <- sparkR.init(master="local[2]",appName="export-to-textfile")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()