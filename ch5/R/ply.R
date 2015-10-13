# import dataframe
sc <- sparkR.init(master="local[2]",appName="ply")
sqlContext <- sparkRSQL.init(sc)

# we'll test out our exploration with some included data from R's datasets package
r_df <- as.data.frame(lynx)
r_df$year <- c(1821:1934)
# IMPORTANT NOTE: created year column here because couldn't figure out easy way
# to add column (map?) or to combine two DataFrames in SparkR without SparkSQL join.
# rbind?
str(r_df)

df <- createDataFrame(sqlContext, r_df)
head(df)

# create new columns
current_year <- as.integer(format(Sys.Date(), format="%Y"))
df$yrs_ago <- negate(df$year - current_year)
df$decade <- floor(df$year / 10) * 10
showDF(df, numRows = 15)

# delete columns
df$yrs_ago <- NULL
printSchema(df)

# filter
head(filter(df, df$x > 1000))

# groupBy
avg_df <- avg(groupBy(df, df$decade))

# arrange (asc or desc)
head(arrange(avg_df, asc(avg_df$decade)))

# summarize + distinct
head(summarize(groupBy(df, df$decade), count = countDistinct(df$x)))

# summarize, groupBy, avg
head(summarize(groupBy(df, df$decade), avg_x = avg(df$x)))

# summarize, groupBy, counts
head(summarize(groupBy(df, df$decade), num_yrs = n(df$year)))

# sample fraction, w/ + w/o replacement
# sample_frac(x, withReplacement, fraction, seed)
collect(sample_frac(df, FALSE, 0.05))
collect(sample_frac(df, FALSE, 0.05))

collect(sample_frac(df, FALSE, 0.2, 7))
collect(sample_frac(df, FALSE, 0.2, 7))

# mutate
## normalization

## standardization

# handling missing data
## imputation

## gracefully handling bad data

## NA's and NULLs