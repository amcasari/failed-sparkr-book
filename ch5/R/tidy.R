# import dataframe
sc <- sparkR.init(master="local[2]",appName="tidy")
sqlContext <- sparkRSQL.init(sc)

# we'll assume we have an experiment observed daily for ten weeks
experiment <- as.data.frame(matrix(rexp(70, rate=.1), ncol=7))
df <- createDataFrame(sqlContext, experiment)
head(df)

# gather - gather columns into rows -> explode()?

# spread - separate one column into several

# separate - spread rows into columns -> make new columns with datetime functions?

# unite - unit several columns into one -> bring back separate cols?