inputPath  = "/Users/amcasari/repos/triumph-book/ch4/data/hrc-state-dept-emails/Aliases.csv"

Sys.setenv('SPARKR_SUBMIT_ARGS'='--packages com.databricks:spark-csv_2.10:1.0.3 sparkr-shell')

library(SparkR)

sc <- sparkR.init(master="local[2]",appName="csv-load")

sqlContext <- sparkRSQL.init(sc)

df <- read.df(sqlContext, inputPath, source = "com.databricks.spark.csv")
head(df)

sparkR.stop()