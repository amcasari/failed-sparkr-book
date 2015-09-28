library(SparkR)
sc <- sparkR.init(master="local[2]",appName="import-parquet")
sqlContext <- sparkRSQL.init(sc)

# we'll test out converting Michelson Speed of Light Data from R's datasets package
local_df <- createDataFrame(sqlContext, morley)
head(local_df)
# save as a Parquet file, preserving the schema
write.df(local_df, path="morely.parquet", source="parquet", mode="overwrite")

# now we can load the parquet file and check to see we have the same data
df_parquet <- parquetFile(sqlContext, "morley.parquet")
head(df_parquet)

sparkR.stop()