#command line code 
#adapted directly from spark project's  test_sparkSQL.R
#for the purpose of testing simple examples of code and learning


Sys.setenv(SPARK_HOME="/my/spark/home")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-test_example")
sqlContext <- sparkRSQL.init(sc)

mockLines <- c("{\"name\":\"Michael\"}",
               "{\"name\":\"Andy\", \"mmages\":30}",
               "{\"name\":\"Justin\", \"mmages\":19}")
jsonPath <- tempfile(pattern="sparkr-test", fileext=".tmp")
parquetPath <- tempfile(pattern="sparkr-test", fileext=".parquet")
writeLines(mockLines, jsonPath)
df <- jsonFile(sqlContext, jsonPath)

lines <- c("{\"name\":\"Bob\", \"age\":24}",
           "{\"name\":\"Andy\", \"age\":30}",
           "{\"name\":\"James\", \"age\":35}")
jsonPath2 <- tempfile(pattern="sparkr-test", fileext=".tmp")
writeLines(lines, jsonPath2)
df2 <- read.df(sqlContext, jsonPath2, "json")

collect(df)
collect(df2)

unioned <- rbind(df, df2)
collect(unioned)

unioned2 <- arrange(rbind(df, df2), df$name)
collect(unioned2)
#age    name
#1  30    Andy
#2  30    Andy
#3  24     Bob
#4  35   James
#5  19  Justin
#6  NA Michael

unioned3 <- arrange(rbind(df, df2), df$age)
collect(unioned3)
#age    name
#1  NA Michael
#2  19  Justin
#3  24     Bob
#4  30    Andy
#5  30    Andy
#6  35   James


