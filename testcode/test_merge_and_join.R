#adapted directly from spark project's  test_sparkSQL.R
#for the purpose of testing simple examples of code and learning


Sys.setenv(SPARK_HOME="/my/spark/home")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-example", sparkPackages="com.databricks:spark-csv_2.11:1.2.0")
sqlContext <- sparkRSQL.init(sc)

mockLines <- c("{\"name\":\"Michael\"}",
               "{\"name\":\"Andy\", \"age\":30}",
               "{\"name\":\"Justin\", \"age\":19}")
jsonPath <- tempfile(pattern="sparkr-test", fileext=".tmp")
parquetPath <- tempfile(pattern="sparkr-test", fileext=".parquet")
writeLines(mockLines, jsonPath)
df1 <- jsonFile(sqlContext, jsonPath)
printSchema(df1)

mockLines2 <- c("{\"name\":\"Michael\", \"test\": \"yes\", \"age\":30      }",
                "{\"name\":\"Andy\",  \"test\": \"no\", \"age\":30      }",
                "{\"name\":\"Justin\", \"test\": \"yes\",  \"age\":20   }",
                "{\"name\":\"Bob\", \"test\": \"yes\",  \"age\":55      }")
jsonPath2 <- tempfile(pattern="sparkr-test", fileext=".tmp")
writeLines(mockLines2, jsonPath2)
df2 <- jsonFile(sqlContext, jsonPath2)
printSchema(df2)
collect(merge(df1, df2)) #matches only andy b/c andy matches on all similar fields (name and age)
collect(merge(df1, df2, by = "name")) #matches michael and justin, even though age doesnt match
collect(merge(df1, df2, by.x = "age", by.y = "age", all.y = TRUE))
collect(merge(df1, df2, by.x = "age", by.y = "age", all.x = TRUE))
collect(merge(df1, df2, by.x = "age", by.y = "age", all.x = TRUE, all.y = TRUE, sort=TRUE))
collect(merge(df1, df2, by.x = "age", by.y = "name", all = TRUE, sort = FALSE))
collect(merge(df1, df2, by = "age", all = TRUE, suffixes = c("-X", "-Y")))
