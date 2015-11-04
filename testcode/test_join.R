#command line code
#adapted directly from spark project's  test_sparkSQL.R
#for the purpose of testing simple examples of code and learning

n = c(2, 3, 5)
s = c("aa", "bb", "cc")
b = c(TRUE, FALSE, TRUE)
df = data.frame(n, s, b)
df1= createDataFrame(sqlContext, df)
showDF(df1)

x = c(2, 3, 10)
t = c("dd", "bb", "ff")
c = c(FALSE, FALSE, TRUE)
dff = data.frame(x, t, c)
df2 = createDataFrame(sqlContext, dff)
showDF(df2)


res = join(df1, df2, df1$n == df2$x)
showDF(res)

df3 <- join(df1, df2, df1$n==df2$x & df1$s==df2$t)

