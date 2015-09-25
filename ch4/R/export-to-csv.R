library(SparkR)
sc <- sparkR.init(master="local[2]",appName="create-sparkr-df")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()