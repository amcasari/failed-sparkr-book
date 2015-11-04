#command line code
#adapted directly from spark project's  test_sparkSQL.R
#for the purpose of testing simple examples of code and learning

Sys.setenv(SPARK_HOME="/my/spark/home")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-test_example")
sqlContext <- sparkRSQL.init(sc)


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

