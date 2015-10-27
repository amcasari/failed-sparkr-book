# import dataframe
sc <- sparkR.init(master="local[2]",appName="explore")
sqlContext <- sparkRSQL.init(sc)

# we'll test out our exploration with some included data from R's datasets package
r_df <- morley
str(r_df)

df <- createDataFrame(sqlContext, r_df)

# find out more about df
head(df) # returns a data.frame
head(df,2) # returns a data.frame
showDF(df, numRows = 5)
dtypes(df) # returns a list
columns(df) # returns a character
show(df) # no return
printSchema(df) # no return

# summary allows a quick stats update for data.frame
# IMPORTANT NOTE: add in note about how collect brings things down to local
local <- collect(summary(df))
local
typeof(local)

# describe gives same, also allows you to focus on specific columns
collect(describe(df))
show(describe(df))
collect(describe(df, "Expt", "Run"))

# column access
head(select(df, "Expt"))
head(select(df, df$Expt))
selected_cols <- select(df,df[[1]])
head(selected_cols, 2)
selected_cols2 <- df[,c("Speed","Expt")]
head(selected_cols2, 2)

# create new columns
df$ExptF <- cast(df$Expt, "string")
head(select(df, df$ExptF))
printSchema(df)

# delete columns
df$ExptF <- NULL
printSchema(df)

# average
head(summarize(groupBy(df, df$Expt), avg_sp = avg(df$Speed)))

# counts
head(summarize(groupBy(df, df$Expt), num_runs = n(df$Run)))

# categorical variables / factors...
# TODO: not sure where to go with this
df$ExptF <- cast(df$Expt, "string")
head(select(df, df$ExptF))
printSchema(df)

# initial viz: histograms
hec <- as.data.frame(HairEyeColor)
head(hec)
# can do this in SparkR using sql + agg functions
hdf <- createDataFrame(sqlContext, hec)
printSchema(hdf)

registerTempTable(hdf, "haireyecolor")
second_table <- sql(sqlContext, "select Hair,
                    Eye,
                    sum(Freq) as Freq from haireyecolor group by Hair, Eye order by Hair")
head(second_table)

library(ggplot2)
qplot(Freq, data = collect(second_table), geom = "histogram")

# initial viz: scatter plots
qplot(Hair, Freq, data = take(second_table, 10))

sparkR.stop()