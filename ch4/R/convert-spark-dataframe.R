library(SparkR)
sc <- sparkR.init(master="local[2]",appName="convert-spark-dataframe")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()