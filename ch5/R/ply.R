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
#subsetdf <- df[df$Speed %in% c(850, 740) & df$Expt == 1, 1:2]
#head(subsetdf)

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

collect(sample_frac(df, FALSE, 0.1, 7))
collect(sample_frac(df, FALSE, 0.1, 7))

# mutate
## normalization
df$norm_x <- df$x / max(collect(select(df, "x")))
showDF(df, numRows = 5)

## standardization
df_stats <- collect(describe(df))
df_stats
typeof(df_stats) # list! let's steal these things...
x_mu <- as.numeric(df_stats[2,2])
x_sigma <- as.numeric(df_stats[3,2])
df$standard_score <- (df$x - x_mu) / x_sigma
showDF(df, numRows = 5)

sparkR.stop()