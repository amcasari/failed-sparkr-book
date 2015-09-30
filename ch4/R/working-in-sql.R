library(SparkR)
sc <- sparkR.init(master="local[2]",appName="working-in-sql")
sqlContext <- sparkRSQL.init(sc)

sparkR.stop()

