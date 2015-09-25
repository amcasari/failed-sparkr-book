sparkPath = "/Users/amcasari/sandbox/spark-1.5.0-bin-hadoop2.6/"
inputPath  = "/Users/amcasari/repos/triumph-book/ch4/data/hrc-state-dept-emails/Persons.csv"
inputPath2 = "/Users/amcasari/repos/triumph-book/ch4/data/accident.csv"
outputPath  = "/Users/amcasari/repos/triumph-book/ch4/data/hrc-state-dept-emails/new-people.csv"

Sys.setenv(SPARK_HOME=sparkPath)
Sys.setenv('SPARKR_SUBMIT_ARGS'='--packages com.databricks:spark-csv_2.10:1.0.3 sparkr-shell')

.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))

library(SparkR)

sc <- sparkR.init(master="local[2]",appName="csv-load")

sqlContext <- sparkRSQL.init(sc)

df <- read.df(sqlContext, inputPath, source = "com.databricks.spark.csv")
df2 <- read.df(sqlContext, inputPath2, source = "com.databricks.spark.csv")

# do something
newdf <- select(df, count(df1$C1))

# collect
collect(newdf)

# do 
#write.df(df, outputPath, "com.databricks.spark.csv", "overwrite")
sparkR.stop()