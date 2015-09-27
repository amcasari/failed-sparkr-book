library(SparkR)
sc <- sparkR.init(master="local[2]",appName="spark-r-word-count")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()