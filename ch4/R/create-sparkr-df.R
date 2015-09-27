library(SparkR)
sc <- sparkR.init(master="local[2]",appName="create-sparkr-df")
sqlContext <- sparkRSQL.init(sc)

# set up a local data frame
expt <- c(0, 1, 2, 3, 4, 5)
run  <- c(2, 3, 4, 4, 6, 7)

x <- c(299792000:299793000)
speed <- base::sample(x, 6, replace = TRUE)

localr_df <- data.frame(expt, run, speed)
str(localr_df)

sparkr_df <- createDataFrame(sqlContext, localr_df)
head(sparkr_df)

sparkR.stop()