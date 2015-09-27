library(SparkR)
sc <- sparkR.init(master="local[2]",appName="convert-local-dataframe")
sqlContext <- sparkRSQL.init(sc)

# we'll test out converting Michelson Speed of Light Data from R's datasets package
df <- createDataFrame(sqlContext, morley)
head(df)
# save as a Parquet file, preserving the schema
saveAsParquetFile(df, "morley.parquet")

# now we can load the parquet file and check to see we have the same data
df.parquet <- parquetFile(sqlContext, "morley.parquet")
head(df.parquet)

sparkR.stop()