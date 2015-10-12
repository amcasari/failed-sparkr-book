# import dataframe
sc <- sparkR.init(master="local[2]",appName="explore")
sqlContext <- sparkRSQL.init(sc)

# we'll test out converting morley, Michelson Speed of Light Data from R's datasets package
r_df <- morley
str(r_df)

df <- createDataFrame(sqlContext, r_df)

# find out more about df
head(df) # returns a data.frame
showDF(df, numRows = 10)
dtypes(df) # returns a list
columns(df) # returns a character
show(df) # no return
printSchema(df) # no return

# summary allows a quick stats update for data.frame
collect(summary(df))

# describe gives same, also allows you to focus on specific columns
collect(describe(df))
show(describe(df))
collect(describe(df, "Expt", "Run"))

# column access
head(select(df, "Expt"))
head(select(df, df$Expt))

# create new columns
df$ExptF <- cast(df$Expt, "string")
head(select(df, df$ExptF))
printSchema(df)

# delete columns
df$ExptF <- NULL
printSchema(df)

# crosstab
registerTempTable(df, "table_df")
new_df <- sql(sqlContext, "select * from table_df")
#TO DO: table + can we do crosstab with sql?

# average per experiment
head(summarize(groupBy(df, df$Expt), avg_sp = avg(df$Speed)))

# counts
head(summarize(groupBy(df, df$Expt), num_runs = n(df$Run)))

# two-way contingency tables
# find a new dataset
HairEyeColor
hec <- as.data.frame(HairEyeColor)
# can do this easily in R using xtabs from stats package
xtabs(Freq ~ Hair + Eye, hec)
# can do this in SparkR using sql + agg functions
hdf <- createDataFrame(sqlContext, hec)
printSchema(hdf)

# using crosstab doesn't work the same here because of the shape of our data
first_table <- crosstab(hdf, "Hair", "Eye")
show(first_table)

# but we can use SparkSQL to get our counts + frequencies
registerTempTable(hdf, "haireyecolor")
second_table <- collect(sql(sqlContext, "select Hair,
                   Eye,
                   sum(Freq) as Counts from haireyecolor group by Hair, Eye order by Hair"))
head(second_table)

# categorical variables / factors...
# not sure where to go with this
df$ExptF <- cast(df$Expt, "string")
head(select(df, df$ExptF))
printSchema(df)

# initial viz: histograms

# initial viz: scatter plots

sparkR.stop()