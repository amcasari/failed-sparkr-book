# Ref: https://github.com/databricks/spark-avro
# Ref: 

Sys.setenv('SPARKR_SUBMIT_ARGS'='--packages com.databricks:com.databricks:spark-avro_2.10:2.0.1')
library(SparkR)

sc <- sparkR.init(master="local[2]",appName="avro-load", sparkPackages = "com.databricks:spark-avro_2.10:2.0.1")
sqlContext <- sparkRSQL.init(sc)

# THIS DOESN"T WORK: STILL FIGURING OUT SYNTAX
avro_df <- SparkR:::sqlContext.read.format("com.databricks.spark.avro").load("/Users/amcasari/repos/triumph-book/ch4/data/episodes.avro")
head(avro_df)

outputPath <- ""
write.df(avro_df, outputPath, "com.databricks:spark-avro", "overwrite")

sparkR.stop()