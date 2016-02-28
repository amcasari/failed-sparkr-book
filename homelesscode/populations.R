setwd("/Users/deborahsiegel/software/spark-1.6.0-bin-hadoop2.4")
Sys.setenv(SPARK_HOME="/Users/deborahsiegel/software/spark-1.6.0-bin-hadoop2.4")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
sc <- sparkR.init(master="local[2]",appName="SparkR-example", sparkPackages="com.databricks:spark-csv_2.11:1.2.0")
sqlContext <- sparkRSQL.init(sc)
install.packages("magrittr")
library(magrittr)
library(help="SparkR")  #this doesn't work for 1.5.1 but works again for 1.6.0

#nb problems with the structType thingie in 1.5.0 but works in 1.4.1

#note to read from s3 need to export your aws key and secret key and launch rstudio from same shell
#export AWS_ACCESS_KEY_ID=""
#export AWS_SECRET_ACCESS_KEY=""
#open -a RStudio .


#this puts headers with spaces. use a schema
populations2 <- read.df(sqlContext, "s3n://1000genomes/20131219.populations.tsv", "com.databricks.spark.csv", header="true", delimiter="\t")

population_schema <- structType(structField("Population_Description", "string"), structField("Population_Code", "string"), structField("Super_Population", "string"), structField("DNA_from_Blood", "string"), structField("Offspring_available_from_Trios", "string"),structField("Pilot_Samples", "string"), structField("Phase1_Samples", "string"), structField("Final_Phase_Samples", "string"), structField("Total", "string"))
populations <- read.df(sqlContext, "s3n://1000genomes/20131219.populations.tsv", "com.databricks.spark.csv", header="true", delimiter="\t", schema = population_schema)


#these work in 1.4.1 and not 1.5.0. actually, once i updated the csv reader package it works again in 1.5.0
#showDF(populations)
head(populations)
#printSchema(populations)
#populations %>% head()

first(populations)$Population_Code
take(populations,5)$Population_Code
collect(describe(populations))

df <- populations %>% withColumnRenamed(existingCol = 'Population_Code', newCol = 'PC')
registerTempTable(df, 'df')
sql(sqlContext, "SELECT DNA_from_Blood, PC, IF(PC LIKE 'CDX', 'yes', 'no') AS PCYN FROM df")  %>% showDF()
newdf <- sql(sqlContext, "SELECT DNA_from_Blood, PC, IF(PC LIKE 'CDX', 'yes', 'no') AS PCYN FROM df")
showDF(newdf)
---
  
pops <- distinct((select(populations, populations$Population_Code, populations$Population_Description))) 
collect(pops)
count(pops)
pops2 <- distinct((select(populations, populations[[1]])))
collect(pops2)
count(pops2)
#need to also remove the "Total" Row

#summary of number of phase 1 samples per population
summary <- summary(select(populations, "Phase1_Samples"))
collect(summary)



#select columns syntax
popcode <- select(populations,populations[[2]])
head(popcode)
popcodeanddescript <- populations[,c("Population_Code","Population_Description")]
head(popcodeanddescript)
# Similar to R data frames columns can also be selected using `$`
rr <- select(populations,populations$Population_Code)
head(rr)

myvars <- c("Population_Code","Population_Description")
concated <- populations[,myvars] #yep
newdata <- populations[,c("Population_Code","Population_Description")] #yep
newdata <- populations[,1] #yep
newdata <- populations[1,] #nope. cant really select rows this way. 

# select 1st and 5th thru 10th variables
newdata <- select(populations,[c(1,5:10)]) #nope
newdata <- select(populations,populations[[c(1,5:10)]]) #nope

