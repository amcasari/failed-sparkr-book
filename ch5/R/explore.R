# import dataframe
sc <- sparkR.init(master="local[2]",appName="explore")
sqlContext <- sparkRSQL.init(sc)

# we'll test out our exploration with some included data from R's datasets package
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
# IMPORTANT NOTE: add in note about how collect brings things down to local
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

# average
head(summarize(groupBy(df, df$Expt), avg_sp = avg(df$Speed)))

# counts
head(summarize(groupBy(df, df$Expt), num_runs = n(df$Run)))

# crosstab
# find a new dataset
HairEyeColor
hec <- as.data.frame(HairEyeColor)
head(hec)
# can do this easily in R using xtabs from stats package
xtabs(Freq ~ Hair + Eye, hec)
# can do this in SparkR using sql + agg functions
hdf <- createDataFrame(sqlContext, hec)
printSchema(hdf)

# using crosstab doesn't work the same here because of the shape of our data
first_table <- crosstab(hdf, "Hair", "Eye")
show(first_table)
# nb> this returns a local R data.frame

# but we can use SparkSQL to get our counts
registerTempTable(hdf, "haireyecolor")
second_table <- sql(sqlContext, "select Hair,
                    Eye,
                    sum(Freq) as Freq from haireyecolor group by Hair, Eye order by Hair")
head(second_table)

# two-way contingency tables
# and we can use SparkSQL to get our row + column frequencies
by_hair <- agg(groupBy(second_table, second_table$Hair), sum_per = sum(second_table$Freq))
by_eye <- agg(groupBy(second_table, second_table$Eye), sum_per = sum(second_table$Freq))
head(by_hair)
# TODO: how to divide by matching on HAIR or EYE?

# categorical variables / factors...
# TODO: not sure where to go with this
df$ExptF <- cast(df$Expt, "string")
head(select(df, df$ExptF))
printSchema(df)

# initial viz: histograms
#TODO: BETTER DATA EXAMPLE THAN THIS
library(ggplot2)
qplot(Freq, data = collect(second_table), geom = "histogram")

# initial viz: scatter plots
#TODO: BETTER DATA EXAMPLE THAN THIS
qplot(Hair, Freq, data = take(second_table, 10))

sparkR.stop()