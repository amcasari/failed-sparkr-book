library(SparkR)
sc <- sparkR.init(master="local[2]",appName="convert-local-dataframe")
sqlContext <- sparkRSQL.init(sc)

# we'll test out converting morley, Michelson Speed of Light Data from R's datasets package
r_df <- morley
str(r_df)

df <- createDataFrame(sqlContext, r_df)
head(df)

sparkR.stop()