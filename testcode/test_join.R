#command line code
#adapted directly from spark project's  test_sparkSQL.R and other examples
#for the purpose of testing simple examples of code and learning

Sys.setenv(SPARK_HOME="/my/spark/home")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-test_example")
sqlContext <- sparkRSQL.init(sc)

mockLines <- c("{\"name\":\"Michael\"}",
               "{\"name\":\"Andy\", \"age\":30}",
               "{\"name\":\"Justin\", \"age\":19}")
jsonPath <- tempfile(pattern="sparkr-test", fileext=".tmp")
writeLines(mockLines, jsonPath)
df <- jsonFile(sqlContext, jsonPath)

mockLines2 <- c("{\"name\":\"Michael\", \"test\": \"yes\"}",
                  "{\"name\":\"Andy\",  \"test\": \"no\"}",
                  "{\"name\":\"Justin\", \"test\": \"yes\"}",
                  "{\"name\":\"Bob\", \"test\": \"yes\"}")
jsonPath2 <- tempfile(pattern="sparkr-test", fileext=".tmp")
writeLines(mockLines2, jsonPath2)
df2 <- jsonFile(sqlContext, jsonPath2)

joined <- join(df, df2)
joined2 <- join(df, df2, df$name == df2$name)
joined3 <- join(df, df2, df$name == df2$name, "rightouter")
joined4 <- select(join(df, df2, df$name == df2$name, "outer"),
                    alias(df$age + 5, "newAge"), df$name, df2$test)
joined5 <- join(df, df2, df$name == df2$name, "leftouter")
joined6 <- join(df, df2, df$name == df2$name, "inner")
joined7 <- join(df, df2, df$name == df2$name, "leftsemi")
joined8 <- join(df, df2, df$name == df2$name, "left_outer")
joined9 <- join(df, df2, df$name == df2$name, "right_outer")

################
another examples
###################

n <- c(2, 3, 5)
s <- c("aa", "bb", "cc")
b <- c(TRUE, FALSE, TRUE)
df <- data.frame(n, s, b)
df1 <- createDataFrame(sqlContext, df)

x <- c(2, 3, 10)
t <- c("dd", "bb", "ff")
c <- c(FALSE, FALSE, TRUE)
dff <- data.frame(x, t, c)
df2 <- createDataFrame(sqlContext, dff)

res <- join(df1, df2, df1$n == df2$x)
showDF(res)

df3 <- join(df1, df2, df1$n==df2$x & df1$s==df2$t)

#############
#another example
##############
x <- data.frame(k1 = c(NA,NA,3,4,5), k2 = c(1,NA,NA,4,5), data = 1:5)
y <- data.frame(k1 = c(NA,2,NA,4,5), k2 = c(NA,NA,3,4,5), data = 1:5)
xdf <- createDataFrame(sqlContext, x) 
ydf <- createDataFrame(sqlContext, y) 
res <- join(xdf,ydf)
head(res)

