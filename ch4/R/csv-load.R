#
# Ref: http://spark-packages.org/package/databricks/spark-csv

Sys.setenv('SPARKR_SUBMIT_ARGS'='--packages com.databricks:spark-csv_2.11:1.2.0 sparkr-shell')
library(SparkR)

sc <- sparkR.init(master="local[2]",appName="csv-load", sparkPackages = "com.databricks:spark-csv_2.11:1.2.0")
sqlContext <- sparkRSQL.init(sc)

inputPath  = "/Users/amcasari/repos/triumph-book/ch4/data/hrc-state-dept-emails/Aliases.csv"
csv_df <- read.df(sqlContext, inputPath, source = "com.databricks.spark.csv", header = "true")
head(csv_df)

outputPath <- "/Users/amcasari/repos/triumph-book/ch4/data/hrc-state-dept-emails/new-csv"
write.df(csv_df, outputPath, "com.databricks.spark.csv", "overwrite")

sparkR.stop()