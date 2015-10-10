# import dataframe

sc <- sparkR.init(master="local[2]",appName="explore")
sqlContext <- sparkRSQL.init(sc)

# we'll test out converting morley, Michelson Speed of Light Data from R's datasets package
r_df <- morley
str(r_df)

df <- createDataFrame(sqlContext, r_df)

# find out more about df
head(df) # returns a data.frame
dtypes(df) # returns a list
columns(df) # returns a character
printSchema(df) # no return

describe(df)
summary(df)

# column access
head(select(df, "Expt"))
df

# create new columns

# crosstab

# ave

# 2-way tables

# counts

# categorical variables/ factors

# initial viz: histograms

# initial viz: scatter plots

sparkR.stop()